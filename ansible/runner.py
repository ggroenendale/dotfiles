from pathlib import Path
from ansible.executor.playbook_executor import PlaybookExecutor
from ansible.inventory.manager import InventoryManager
from ansible.parsing.dataloader import DataLoader
from ansible.vars.manager import VariableManager
from ansible.utils.display import Display
import argparse

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


#
# inventory = InventoryManager(loader=loader, sources=["localhost,"])
# variable_manager = VariableManager(loader=loader, inventory=inventory)
#
# passwords = {}
#
# playbook_path = Path(__file__).joinpath("playbooks", filename)
#
# # Instantiate a playbook executor to get rid of excessive ansible print statements
# executor = PlaybookExecutor(
#     playbooks=[playbook_path],
#     inventory=inventory,
#     variable_manager=variable_manager,
#     loader=loader,
#     passwords=passwords,
# )
#
# # Run the executor
# executor.run()

print(f"Can the runner even be reach correctly? - Attempt run of: {filename}")
