Markdown
# 📱 IA-MES Mobile & Web (`suporte_mes_app`)

Front-end multiplataforma desenvolvido em **Flutter** para a plataforma **IA-MES** (Sistema Inteligente de Suporte à Execução de Manufatura)[cite: 5, 6, 8]. 

O aplicativo atua como uma central de conhecimento operacional e diagnóstico em tempo real para o chão de fábrica e equipes de suporte TI/MES, integrando uma biblioteca de normas técnicas a um **Assistente de Inteligência Artificial (RAG)**[cite: 6, 8].

---

## 🚀 Principais Funcionalidades

* **📚 Biblioteca de Normas e Base de Conhecimento:**
  * Navegação categorizada por filtros rápidos: **`IOP`** (Instruções Operacionais Padrão), **`TRAINING`** (Treinamentos) e **`EXPLANATION`** (Explicações Técnicas)[cite: 6, 8].
  * Cadastro dinâmico de novos procedimentos e treinamentos diretamente pela interface (`+ Novo IOP/Treinamento`)[cite: 6].

* **🔍 Detalhamento de Procedimentos e Rastreabilidade:**
  * Visualização limpa e focada de cada norma ou incidente operacional (ex: *"Lote não aparece na tela"*, *"Lote desaparecido"*)[cite: 6, 7].
  * Identificação rápida por tags de contexto: **ID da IOP**, **Equipamento/Linha** (ex: `LTQ`, `LRC`, `LTF`, `GERAL`) e **Chamado de Referência** (ex: `123456-1`) com atalhos de cópia rápida para agilizar o atendimento de chamados[cite: 7].

* **🤖 Assistente IA Integrado (RAG no Suporte MES):**
  * Chat interativo de suporte onde o operador ou analista descreve o problema em linguagem natural[cite: 8].
  * Respostas estruturadas com **Correlação Semântica**, identificando automaticamente a **IOP Correta**, o código do documento e o passo a passo detalhado de resolução nas telas do sistema (ex: *Tela 4J11 - Acessar a tela de lote no LTQ, verificar status de erro e atualização*)[cite: 8].

* **🔐 Segurança e Controle de Acesso:**
  * Autenticação e gerenciamento de sessão integrados ao **Keycloak** (OAuth2 / OIDC), garantindo acesso seguro e controlado por perfil de usuário.

---

## 🛠️ Stack Tecnológica e Integração

**Front-end (Este Repositório):**
* **Framework:** Flutter (Suporte multiplataforma para Android, iOS e Web)[cite: 5, 6]
* **Linguagem:** Dart
* **Comunicação:** Consumo de APIs RESTful com suporte a CORS e interceptação de tokens JWT.

**Ecossistema Back-end Conectado ([IA-MES](https://github.com/LucasMathews1995/IA-MES)):**
* **API Core:** Java com Quarkus Framework
* **Inteligência Artificial:** LangChain4j + Ollama (LLMs locais)
* **Banco de Dados & Busca Vetorial:** PostgreSQL + `pgvector`
* **Identity Provider (IAM):** Keycloak

---

## ⚙️ Como Executar o Projeto Localmente

### Pré-requisitos
* [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e configurado[cite: 5].
* Back-end da API **IA-MES** rodando (padrão em `http://localhost:8080`).
* Servidor **Keycloak** ativo para autenticação.

### Passo a passo

1. **Clone este repositório:**
   ```bash
   git clone [https://github.com/LucasMathews1995/IA-MES-Mobile.git](https://github.com/LucasMathews1995/IA-MES-Mobile.git)
   cd IA-MES-Mobile
