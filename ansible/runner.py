from pprint import pprint
import argparse
import getpass
from ansible.module_utils.common.collections import ImmutableDict

from pathlib import Path
from ansible.executor.playbook_executor import PlaybookExecutor
from ansible.inventory.manager import InventoryManager
from ansible.parsing.dataloader import DataLoader
from ansible.vars.manager import VariableManager
from ansible.utils.vars import load_extra_vars, load_options_vars
from ansible.utils.display import Display
from ansible.plugins.loader import init_plugin_loader
from ansible.cli.playbook import PlaybookCLI

from ansible import context
from ansible.module_utils.ansible_release import __version__ as ansible_version

# Custom arguments to get custom playbook url
parser = argparse.ArgumentParser(
    prog="Ansible Pull Runner",
    description="Runs ansible pull with python API instead of CLI",
    epilog="I dont know what this section is for",
)

# Define an argument for the filename
parser.add_argument("filename")

# Retrieve the args
args = parser.parse_args()

# Retrieve the playbook filename
filename = args.filename

passwords = {
    "become_pass": getpass.getpass("Sudo password: ")
}

playbook_path = Path(__file__).parent.joinpath("playbooks", filename)

cli = PlaybookCLI(
    [
        "ansible-playbook",
        str(playbook_path),
        "--extra-vars",
        f"ansible_version={ansible_version}",
    ]
)
cli.parse()

# Define cliargs
cliargs = dict(context.CLIARGS)
cliargs["connection"] = "local"
cliargs["verbosity"] = 0

# Repackage CLIARGS
context.CLIARGS = ImmutableDict(**cliargs)

# ---- Plugin loader (REQUIRED) ----
init_plugin_loader()

# Define playbook stuff
loader = DataLoader()

# Define a basic inventory for localhost
inventory = InventoryManager(loader=loader, sources=["localhost,"])

# Variable manager is how we insert ansible version information
variable_manager = VariableManager(
    loader=loader,
    inventory=inventory,
    version_info={
        "string": ansible_version.strip(),
        "full": ansible_version,
        "major": ansible_version.split(".")[0],
        "minor": ansible_version.split(".")[1],
        "revision": ansible_version.split(".")[2],
    },
)

# Extra vars needs more testing
extra_vars = {"extra_version_info": ansible_version, "extra_test": "is_extra"}

# extra_vars = load_extra_vars(loader=loader)
variable_manager._extra_vars = extra_vars

# Instantiate a playbook executor to get rid of excessive ansible print statements
executor = PlaybookExecutor(
    playbooks=[str(playbook_path)],
    inventory=inventory,
    variable_manager=variable_manager,
    loader=loader,
    passwords=passwords,
)

# Run the executor
executor.run()
