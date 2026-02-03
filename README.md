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

## 🚀 Implementação e Testes: Nginx & Security Policies
Esta seção descreve a jornada desde a criação do servidor Nginx até a validação das camadas de segurança via GitOps.

1. Criação do Servidor (Manifesto Declarativo)
O primeiro passo foi definir o Pod do Nginx. Para garantir que as políticas de rede consigam "encontrar" o pod, utilizamos o label run: nginx-test.

Arquivo: apps/nginx/nginx-test.yaml

2. Ciclo de Vida via GitOps (Kustomize + ArgoCD)
Para que o Kubernetes reconheça o novo recurso, ele foi registrado no ecossistema de automação:

Registro: O arquivo foi adicionado ao kustomization.yaml na pasta base.

Sincronização: Após o git push, o ArgoCD detectou a alteração e realizou o provisionamento automático no cluster.

Monitoramento: A saúde do Pod foi validada via K9s, garantindo o status Running.

3. Protocolo de Testes de Segurança (Network Policies)
Com o ambiente rodando, executamos os testes de Egress Control (controle de saída) para validar a política de Zero Trust.

A. Teste de Resolução de DNS (Porta 53)
Objetivo: Validar se o Pod consegue consultar o CoreDNS do cluster.

Comando: kubectl exec -it nginx-test -- nslookup google.com

Resultado esperado: SUCESSO. O retorno deve exibir os endereços IP do Google.

B. Teste de Acesso Web (Porta 80)
Objetivo: Validar se o bloqueio total (default-deny) está funcionando para tráfego externo.

Comando: kubectl exec -it nginx-test -- curl -I google.com --connect-timeout 5

Resultado esperado: BLOQUEADO. O comando deve resultar em Timeout, pois não há regra liberando a porta 80 para a internet.

## 🛠️ Comandos Úteis (Cheat Sheet)

Entrar no Pod:	``` kubectl exec -it nginx-test -- sh	s ``` <br>
Ver Logs:	``` kubectl logs nginx-test	l ``` <br>
Ver Detalhes/Labels:	``` kubectl describe pod nginx-test	i ``` <br>
Listar com Labels:	``` kubectl get pods --show-labels	- ``` <br>
Forçar Sincronização:	``` argocd app sync root-app	- ``` <br>




O que você acha dessa versão? Ela cobre desde a declaração do YAML até os resultados práticos dos testes. 
Próximo passo: Agora faça você a converção desse Pod em um Deployment agora para testar a parte de "ele subir sozinho" na prática?

# 💡 Dicas
1. Use o modo "sem GUI" no virtualbox para economizar recursos de hardware e simular um ambiente mais próximo do real.
2. Execute o script abaixo para conseguir administrar o cluster via `kubectl`.

## Cria a pasta .kube se não existir
mkdir -p ~/.kube

## Copia o arquivo da VM para o seu PC (ajuste o IP e usuário)
scp seu-usuario@IP-DA-VM:/etc/rancher/k3s/k3s.yaml ~/.kube/config-k3s