# 🛡️ Kubernetes Secure GitOps Lab

Este repositório contém a implementação de um ambiente de Kubernetes focado em **GitOps**, **Segurança de Rede** e **Imutabilidade**. O objetivo é demonstrar padrões de nível de produção em um ambiente controlado.

## 🚀 Arquitetura do Lab
O lab foi construído utilizando **K3s** em uma VM Ubuntu Server, gerenciado remotamente via `kubectl` no Lubuntu.

* **Continuous Deployment:** ArgoCD (GitOps Engine).
* **Segurança de Rede:** Network Policies (Zero-Trust Model).
* **Controle de Acesso:** RBAC (Least Privilege Principle).
* **Análise Estática:** GitHub Actions + Kube-Linter.

## 🛠️ Componentes Técnicos
### 1. GitOps & Anti-Drift
Utilizamos o **ArgoCD** para garantir que o estado do cluster seja idêntico ao definido neste repositório. Alterações manuais via `kubectl` são automaticamente revertidas pelo controlador de sincronização.

### 2. Network Security (Shift-Left)
Implementação de políticas `default-deny-all` para isolamento total de namespaces, permitindo apenas tráfego explicitamente autorizado.

### 3. RBAC Hardening
Configuração de `ClusterRoles` de leitura para desenvolvedores, limitando o raio de explosão (*blast radius*) em caso de comprometimento de credenciais.

## 📖 Como reproduzir
1. Provisionar uma VM (Ubuntu Server) com 4GB RAM e com no minímo duas vCPUs.
2. Executar o script de setup: `sh scripts/install-k3s.sh`.
3. Instale o ArgoCD: kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml.
4. Aplique o Root App: kubectl apply -f argocd/apps/root-app.yaml.
5. O ArgoCD fará o provisionamento automático de todas as políticas de segurança.

## Dicas
1. Use o modo "sem GUI" no virtualbox para economizar recursos de hardware e simular um ambiente mais próximo do real.
2. Execute o script abaixo para conseguir administrar o cluster via `kubectl`.

# Cria a pasta .kube se não existir
mkdir -p ~/.kube

# Copia o arquivo da VM para o seu PC (ajuste o IP e usuário)
scp seu-usuario@IP-DA-VM:/etc/rancher/k3s/k3s.yaml ~/.kube/config-k3s