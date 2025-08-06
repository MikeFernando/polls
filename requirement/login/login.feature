Feature: Login
Como um cliente
Quero poder acessar minha conta e me manter logado
Para que eu possa ver e responder enquetes de forma rápida

  Scenario: Credenciais Válidas
Dado que o cliente informou credenciais válidas
Quando solicitar para fazer Login
Então o sistema deve enviar o usuário para a tela de enquetes
E manter o usuário logado

  Scenario: Credenciais Inválidas
Dado que o cliente informou credenciais inválidas
Quando solicitar para fazer Login
Então o sistema deve exibir uma mensagem de erro
