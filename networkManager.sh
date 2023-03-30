#!/bin/bash

passwordUser=""

termsFile="/home/angelo/Documentos/projects/network-manager/termsFile.txt"
TermsConditions=$(zenity --text-info --title="Licença" --filename=$termsFile --checkbox="Eu li e aceito os termos.")

if [ "$TermsConditions" == "FALSE" ]
then
  # Usuário clicou em "Cancelar"
  exit 1
else
  # Usuário clicou em "Eu li e aceito os termos"
  response=$(zenity --password)
  passwordUser=$(echo "$response" | cut -f1 -d "|")
fi

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
            nomeHostname=$(hostname)
            setHostname=$(zenity --entry --title="Configurar nome da Máquina (Hostname)")

            if [ $nomeHostname != $setHostname ]
              then
                echo $passwordUser | sudo -S -u root hostname $setHostname
            else
                zenity --warning --text="O novo nome não pode ser igual ao antigo nome!"
            fi
            ;;
        "Exibir nome da máquina")
            hostnameInfo=$(hostname)
            zenity --info --title "Informando o nome da Máquina (Hostname)" --text="O Nome da Máquina (Hostname) é $hostnameInfo."
            ;;
        "Configurar endereço IP")
            ;;
        "Visualizar configurações de interfaces")
            interfacesConfig=$(ip address)
            zenity --info --title "Visualização das Interfaces" --text="\n ${interfacesConfig}"
            ;;
        "Criar rota padrão")
            ;;
        "Remover rota padrão")
            ;;
        "Visualizar rotas")
            rotasConfig=$(ip route)
            zenity --info --title "Visualização das rotas" --text="\n ${rotasConfig}"
            ;;
        "Desativar interface")
            ;;
        "Ativar interface")
            ;;
        "Renovar empréstimo DHCP")
            ;;
        "Gravar servidor DNS")
            ;;
        "Mostrar configuração de servidores DNS")
            servidorDns=$(cat /etc/resolv.conf)
            zenity --info --title "Configuração DNS" --text="\n ${servidorDns}"
            ;;
        "Resolver nome em IP")
            ;;
        "Exibir tabela arp")
            tabelaArp=$(arp) #ip neigh show / ip arp não funciona no meu notebook
            zenity --info --title "Tabela Ar" --text="\n ${tabelaArp}" --width 500 --height 200
            ;;
        "Criar entrada arp estática")
            ;;
        "Remover entrada arp estática")
            ;;
        "Pingar computador")
            ipUsuario=$(zenity --entry --text "Digite o endereço IP:")
            ttlUsuario=$(zenity --entry --text "Digite o valor TTL:")
            pingRequerimento=$(ping -t $ttlUsuario $ipUsuario)
            zenity --info --title "Ping" --text="\n ${pingRequerimento}"
            ;;
        "Pingar computador com tamanho")
            ;;
        "Instalar programa")
            #appUsuario=$(zenity --entry --text "Digite o endereço IP:")
            nomeAplicativo=$(zenity --entry --text "Qual aplicativo deseja instalar?")
            sudo apt-get install $nomeAplicativo | zenity --progress --auto-close --pulsate --text "Instalando $nomeAplicativo"
            zenity --info --text="$nomeAplicativo foi instalado com sucesso."
            ;;
        "Remover programa")
            ;;
        "Sair")
            exit 0
            ;;
        *)
        zenity --error --text="Opção inválida."
        ;;
      esac
done
