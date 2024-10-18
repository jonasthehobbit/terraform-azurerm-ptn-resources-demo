# Gets the output from the remote state and uses it to create a virtual machine
data "terraform_remote_state" "workload" {
  backend = "remote"
  config = {
    organization = "MMUDemo"
    workspaces = {
      name = "terraform-azurerm-ptn-workload-demo"
    }
  }
}
# Uses the naming module to generate a unique name for the virtual machine and network interface
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.1"
  suffix  = ["mmu", "demo"]
}
# Uses the virtual machine module to create a virtual machine with a network interface that is attached to a subnet in the remote state.
module "testvm" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.16.0"

  location            = data.terraform_remote_state.workload.outputs.resource_group_location
  resource_group_name = data.terraform_remote_state.workload.outputs.resource_group_name
  name                = try(var.vm_config["name"], module.naming.virtual_machine.name_unique)
  zone                = 1
  sku_size            = var.vm_config["sku_size"]
  network_interfaces = {
    network_interface_1 = {
      name = module.naming.network_interface.name_unique
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${module.naming.network_interface.name_unique}-ipconfig1"
          private_ip_subnet_resource_id = data.terraform_remote_state.workload.outputs.subnet["wkld_data"]
        }
      }
    }
  }
}
