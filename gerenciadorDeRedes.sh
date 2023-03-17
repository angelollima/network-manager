#!/bin/bash

while true; do
    OPCAO=$(zenity --list --width=1000 --height=650 --title "Gerenciador de Rede" --column "Opção" --column "Descrição" \
        "Configurar nome da máquina" "Configura o nome da máquina" \
        "Exibir nome da máquina" "Exibe o nome da máquina configurado" \
        "Configurar endereço IP" "Configura um endereço IP utilizando o comando ip" \
        "Visualizar configurações de interfaces" "Visualiza as configurações das interfaces de rede utilizando o comando ip" \
        "Criar rota padrão" "Cria uma rota padrão para o roteador informado utilizando o comando ip" \
        "Remover rota padrão" "Remove a rota padrão criada utilizando o comando ip" \
        "Visualizar rotas" "Visualiza as rotas configuradas no sistema utilizando o comando ip" \
        "Desativar interface" "Desativa a interface de rede citada pelo usuário" \
        "Ativar interface" "Ativa a interface de rede citada pelo usuário" \
        "Renovar empréstimo DHCP" "Renova o empréstimo de endereço IP junto ao servidor DHCP para uma interface citada pelo usuário" \
        "Gravar servidor DNS" "Grava o endereço do servidor DNS no arquivo de configuração" \
        "Mostrar configuração de servidores DNS" "Mostra o arquivo com a configuração dos servidores DNS do sistema" \
        "Resolver nome em IP" "Resolve um nome fornecido pelo usuário em um endereço IP" \
        "Exibir tabela arp" "Exibe a tabela arp do computador do usuário utilizando o comando ip" \
        "Criar entrada arp estática" "Cria uma entrada estática na tabela arp do computador utilizando o comando ip" \
        "Remover entrada arp estática" "Remove uma entrada estática na tabela arp do computador utilizando o comando ip" \
        "Pingar computador" "Pinga um computador fornecido pelo usuário com o valor de TTL e a quantidade de pacotes fornecidos por ele" \
        "Pingar computador com tamanho" "Pinga um computador fornecido pelo usuário com tamanho e quantidade de pacotes fornecidos por ele" \
        "Instalar programa" "Instala um programa no sistema utilizando o comando apt" \
        "Remover programa" "Remove um programa do sistema utilizando o comando apt" \
        "Sair" "Sai do Gerenciador de Rede")
    case $OPCAO in
        "Configurar nome da máquina")
            # código para configurar o nome da máquina
            ;;
        "Exibir nome da máquina")
            nomeHostname=$(hostname)
            zenity --info --title "Nome da Máquina" --text="O nome da máquina é $nomeHostname."
            ;;
        "Configurar endereço IP")
            # código para configurar um endereço IP utilizando o comando ip
            ;;
        "Visualizar configurações de interfaces")
          interfacesConfig=$(ip address)
            zenity --info --title "Configurações de Interfaces" --text="$interfacesConfig"
            ;;
        "Criar rota padrão")
            # código para criar uma rota padrão para o roteador informado utilizando o comando ip
            ;;
        "Remover rota padrão")
            # código para remover a rota padrão criada utilizando o comando ip
            ;;
        "Visualizar rotas")
            # código para visualizar as rotas configuradas no sistema utilizando o comando ip
            ;;
        "Desativar interface")
            # código para desativar a interface de rede citada pelo usuário
            ;;
        "Ativar interface")
            # código para ativar a interface de rede citada pelo usuário
            ;;
        "Renovar empréstimo DHCP")
            # código para renovar o empréstimo de endereço IP junto ao servidor DHCP para uma interface citada pelo usuário
            ;;
        "Gravar servidor DNS")
            # código para gravar o endereço do servidor DNS no arquivo de configuração
            ;;
        "Mostrar configuração de servidores DNS")
            # código para mostrar o arquivo com a configuração dos servidores DNS do sistema
            ;;
        "Resolver nome em IP")
            # código para resolver um nome fornecido pelo usuário em um endereço IP
            ;;
        "Exibir tabela arp")
            # código para exibir a tabela arp do computador do usuário utilizando o comando ip
            ;;
        "Criar entrada arp estática")
            # código para criar uma entrada estática na tabela arp do computador utilizando o comando ip
            ;;
        "Remover entrada arp estática")
            # código para remover uma entrada estática na tabela arp do computador utilizando o comando ip
            ;;
        "Pingar computador")
            # código para pingar um computador fornecido pelo usuário com o valor de TTL e a quantidade de pacotes fornecidos por ele
            ;;
        "Pingar computador com tamanho")
            # código para pingar um computador fornecido pelo usuário com tamanho e quantidade de pacotes fornecidos por ele
            ;;
        "Instalar programa")
            # código para instalar um programa no sistema utilizando o comando apt
            ;;
        "Remover programa")
            # código para remover um programa do sistema utilizando o comando apt
            ;;
        "Sair")
            exit 0
            ;;
        *)
        zenity --error --text="Opção inválida."
        ;;
      esac
done
