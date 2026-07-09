import os.path
import subprocess

from goad.log import Log
from goad.utils import *
from goad.goadpath import GoadPath
from goad.jumpbox import JumpBox


class LocalJumpBox(JumpBox):

    def __init__(self, instance, creation=False):
        super().__init__(instance, creation)
        self.username = 'vagrant'
        self.ssh_host = self.ip
        self.ssh_port = 22
        if not creation:
            self._load_vagrant_ssh_config()

    def _load_vagrant_ssh_config(self):
        """Use vagrant ssh-config so Windows host reaches jumpbox via forwarded port."""
        provider_path = os.path.join(self.instance_path, 'provider')
        if not os.path.isdir(provider_path):
            return
        try:
            result = subprocess.run(
                [self.command.vagrant_bin, 'ssh-config', 'PROVISIONING'],
                cwd=provider_path,
                capture_output=True,
                text=True,
                check=False
            )
        except FileNotFoundError:
            return
        if result.returncode != 0:
            Log.warning('Could not read vagrant ssh-config for PROVISIONING; using host-only IP')
            return
        for line in result.stdout.splitlines():
            stripped = line.strip()
            if stripped.startswith('HostName '):
                self.ssh_host = stripped.split(None, 1)[1]
            elif stripped.startswith('Port '):
                self.ssh_port = int(stripped.split(None, 1)[1])
        Log.info(f'Jumpbox SSH target: {self.username}@{self.ssh_host}:{self.ssh_port} (lab IP {self.ip})')

    def _ssh_opts(self):
        return f'-o StrictHostKeyChecking=no -p {self.ssh_port} -i {self.ssh_key}'

    def _scp_opts(self):
        return f'-o StrictHostKeyChecking=no -P {self.ssh_port} -i {self.ssh_key}'

    def provision(self):
        script_name = self.provider.jumpbox_setup_script
        script_file = GoadPath.get_script_file(script_name)
        if not os.path.isfile(script_file):
            Log.error(f'script file: {script_file} not found !')
            return None
        self._scp(script_file, f'{self.username}@{self.ssh_host}:~/setup.sh')
        if Utils.is_windows():
            self.run_command("sudo apt update && sudo apt install -y dos2unix", '~')
            self.run_command("dos2unix setup.sh", '~')
        self.run_command('bash setup.sh', '~')

    def get_jumpbox_key(self, creation=False):
        if not creation:
            provider_folder = f'{self.instance_path}/provider/.vagrant/machines/PROVISIONING/'.replace('/', os.path.sep)
            provider_folders = Utils.list_folders(provider_folder)
            if len(provider_folders) > 0:
                return provider_folder + provider_folders[0] + os.path.sep + 'private_key'
            key_supposed_path = provider_folder + '<provider_name>' + os.path.sep + 'private_key'
            Log.error(f'PROVISIONING ssh key not found at : {key_supposed_path}')
        return None

    def _scp(self, source, destination):
        command = f'scp {self._scp_opts()} {source} {destination}'
        self.command.run_shell(command, self.instance_path)

    def sync_sources(self):
        if Utils.is_valid_ipv4(self.ip):
            self._scp(GoadPath.get_global_inventory_path(), f'{self.username}@{self.ssh_host}:~/GOAD/globalsettings.ini')
            self.run_command('mkdir -p ~/GOAD/workspace/' + self.instance_id, '~')
            for src_file in Utils.list_files(self.instance_path):
                source = self.instance_path + os.path.sep + src_file
                destination_file = f'~/GOAD/workspace/{self.instance_id}/{src_file}'
                destination = f'{self.username}@{self.ssh_host}:{destination_file}'
                self._scp(source, destination)
                if Utils.is_windows():
                    self.run_command(f"dos2unix {destination_file}", '~')
        else:
            Log.error('Can not sync source jumpbox ip is invalid')

    def run_command(self, command, path):
        ssh_cmd = f'ssh -t {self._ssh_opts()} {self.username}@{self.ssh_host} "cd {path} && {command}"'
        return self.command.run_command(ssh_cmd, self.instance_path)

    def ssh(self):
        ssh_cmd = f"ssh {self._ssh_opts()} {self.username}@{self.ssh_host}"
        self.command.run_shell(ssh_cmd, project_path)
