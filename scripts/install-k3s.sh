#!/bin/bash

echo "🔧 Iniciando instalação do K3s otimizada para 4GB de RAM..."

# Instala o K3s desativando o que não precisamos (Traefik e ServiceLB) 
# para sobrar RAM para o ArgoCD e seus Apps.
curl -sfL https://get.k3s.io | sh -s - \
  --disable traefik \
  --disable servicelb \
  --write-kubeconfig-mode 644

echo "✅ K3s instalado!"
echo "⏳ Aguardando nós ficarem prontos..."
sleep 20

kubectl get nodes