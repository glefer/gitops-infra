set dotenv-load := false

default:
    @just --list

# ---------------------------------------------------------------------------
# Terraform
# ---------------------------------------------------------------------------

tf-fmt:
    terraform -chdir=terraform/environments/production fmt -recursive

tf-fmt-check:
    terraform -chdir=terraform/environments/production fmt -check -recursive

tf-init:
    terraform -chdir=terraform/environments/production init

tf-validate:
    terraform -chdir=terraform/environments/production validate

tf-check: tf-fmt-check tf-validate

tf-state-list:
    terraform -chdir=terraform/environments/production state list

# Intentionally no tf-apply:
# production changes are applied through HCP Terraform.

# ---------------------------------------------------------------------------
# Ansible
# ---------------------------------------------------------------------------

ansible-install:
    ansible-galaxy collection install \
        -r ansible/requirements.yml

ansible-hosts:
    cd ansible && ansible all --list-hosts

ansible-ping:
    cd ansible && ansible all -m ping

ansible-syntax:
    cd ansible && \
        ansible-playbook playbooks/bootstrap.yml --syntax-check

ansible-check:
    cd ansible && \
        ansible-playbook playbooks/bootstrap.yml --check --diff

ansible-bootstrap:
    cd ansible && \
        ansible-playbook playbooks/bootstrap.yml

ansible-bootstrap-check:
    just ansible-syntax
    just ansible-check

ansible-observability:
    cd ansible && \
        ansible-playbook playbooks/observability.yml

ansible-observability-check:
    cd ansible && \
        ansible-playbook playbooks/observability.yml --check --diff

ansible-observability-syntax:
    cd ansible && \
        ansible-playbook playbooks/observability.yml --syntax-check

ansible-app:
    cd ansible && \
        ansible-playbook playbooks/app.yml

ansible-app-check:
    cd ansible && \
        ansible-playbook playbooks/app.yml --check --diff

ansible-app-syntax:
    cd ansible && \
        ansible-playbook playbooks/app.yml --syntax-check

ansible-kubeconfig:
    cd ansible && \
        ansible-playbook playbooks/fetch-kubeconfig.yml

ansible-argocd:
    cd ansible && \
        ansible-playbook playbooks/argocd.yml

ansible-argocd-check:
    cd ansible && \
        ansible-playbook playbooks/argocd.yml --check --diff

ansible-argocd-syntax:
    cd ansible && \
        ansible-playbook playbooks/argocd.yml --syntax-check
        
# ---------------------------------------------------------------------------
# Validation
# ---------------------------------------------------------------------------

check: tf-check ansible-syntax

doctor:
    @command -v terraform >/dev/null || (echo "terraform is missing" && exit 1)
    @command -v ansible >/dev/null || (echo "ansible is missing" && exit 1)
    @command -v ansible-playbook >/dev/null || (echo "ansible-playbook is missing" && exit 1)
    @command -v just >/dev/null || (echo "just is missing" && exit 1)
    @echo "All required tools are available."

# ---------------------------------------------------------------------------
# Repository
# ---------------------------------------------------------------------------

status:
    @git status --short

clean:
    rm -rf terraform/environments/production/.terraform
    rm -rf ansible/*.retry

# ---------------------------------------------------------------------------
# Utils
# ---------------------------------------------------------------------------
k8s-tunnel:
    ssh -N \
        -L 6443:127.0.0.1:6443 \
        grayhost@135.125.75.237

k8s-nodes:
    KUBECONFIG="$HOME/.kube/cachelab-platform.yaml" kubectl get nodes -o wide

k8s-pods:
    KUBECONFIG="$HOME/.kube/cachelab-platform.yaml" kubectl get pods -A

k8s-context:
    KUBECONFIG="$HOME/.kube/cachelab-platform.yaml" kubectl config current-context