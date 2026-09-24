variable "aws_region" {
  description = "Região AWS do laboratório"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "TechNova"
}

variable "environment" {
  description = "Ambiente de execução"
  type        = string
  default     = "lab"
}

variable "aluno" {
  description = "Nome completo do aluno"
  type        = string
  default     = "Fábio Panosian"
}

variable "ra" {
  description = "Número de matrícula do aluno"
  type        = string
  default     = "6325250"
}