# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "is_cluster_role" {
  description = "(Optional) Wether you want to bind to a kubernetes role / cluster role."
  type        = bool
  default     = false
}

variable "name" {
  description = "(Required) Name of the kubernetes role / cluster role binding, must be unique. Cannot be updated."
  type        = string
}

variable "role_ref_name" {
  description = "(Required) The name of this Role to bind Subjects to."
  type        = string
}

variable "role_ref_kind" {
  description = "(Required) The type of binding to use. This value must be present and defaults to `Role`."
  type        = string
  default     = "Role"
}

variable "role_ref_api_group" {
  description = "(Required) The API group to drive authorization decisions. This value must be and defaults to `rbac.authorization.k8s.io`."
  type        = string
  default     = "rbac.authorization.k8s.io"
}

variable "subjects" {
  description = "(Required) List of rules that define the set of permissions for this role."
  type        = any

  validation {
    condition     = alltrue([for x in var.subjects : can(x.name)])
    error_message = "All subjects must have a defined name."
  }

  validation {
    condition     = alltrue([for x in var.subjects : contains(["ServiceAccount", "User", "Group"], x.kind)])
    error_message = "All subjects must have a valide subject kind. Allowed values: ServiceAccount, User, Group."
  }

  validation {
    condition     = alltrue([for x in var.subjects : (x.kind == "User" || x.kind == "Group") ? (x.api_group == "rbac.authorization.k8s.io" ? true : false) : true])
    error_message = "All subjects must have a defined api_group and if the subject.kind is `User` or `Group` the `api_group` must be `rbac.authorization.k8s.io`."
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "annotations" {
  description = "(Optional) An unstructured key value map stored with the role / cluster role binding that may be used to store arbitrary metadata."
  type        = any
  default     = null
}

variable "labels" {
  description = "(Optional) Map of string keys and values that can be used to organize and categorize (scope and select) the role / cluster role binding."
  type        = any
  default     = null
}

variable "generate_name" {
  description = "(Optional) Prefix, used by the server, to generate a unique name ONLY IF the name field has not been provided. This value will also be combined with a unique suffix."
  type        = string
  default     = null
}

variable "namespace" {
  description = "(Optional) Namespace defines the space within which name of the role must be unique."
  type        = string
  default     = null
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is 'true'."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is '[]'."
  default     = []
}
