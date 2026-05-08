import argparse
from ansible.module_utils.common.collections import ImmutableDict

from pathlib import Path
from ansible.executor.playbook_executor import PlaybookExecutor
from ansible.inventory.manager import InventoryManager
from ansible.parsing.dataloader import DataLoader
from ansible.vars.manager import VariableManager
from ansible.utils.display import Display
from ansible.plugins.loader import init_plugin_loader

from ansible import context

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

# ---- CLI context (REQUIRED) ----
context.CLIARGS = ImmutableDict(
    connection="local",
    module_path=None,
    forks=10,
    become=None,
    become_method=None,
    become_user=None,
    check=False,
    diff=False,
    verbosity=0,
)

# args = {}

context._init_global_context(parser)

# ---- Plugin loader (REQUIRED) ----
init_plugin_loader()

# Define playbook stuff
loader = DataLoader()

inventory = InventoryManager(loader=loader, sources=["localhost,"])
variable_manager = VariableManager(loader=loader, inventory=inventory)
passwords = {}
playbook_path = Path(__file__).parent.joinpath("playbooks", filename)

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
