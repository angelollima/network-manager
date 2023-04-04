#!/bin/bash

currentDirectory=$(pwd)
formatedDirectory="${currentDirectory}/termsFile.txt"

userPassword=""

#Get the distro that is current bein used
distro=$(grep -E "^(ID|DISTRIB_ID)=" /etc/*-release | awk -F '=' '{print $2}' | tr '[:upper:]' '[:lower:]')
#Declare a "lib"
declare -A distros

interfaces=()

getDirectoryUser()
{
if ! [ -e $formatedDirectory ]
  then
    touch "${currentDirectory}/termsFile.txt"
    echo "A Aplicação necessita de acesso de super-usuário (root) apara algumas funcionalidades, se você permitir acesso, você estará concordando em termos acesso a sua senha de super-usuário, conhecido como root." > termsFile.txt
fi
}

getPasswordUser()
{
  response=$(zenity --password --cancel-label="Cancelar")
  if [ $? -eq 1 ]
    then
      exit 0
  elif [ -z "$response" ]
    then
      userChoice=$(zenity --question --title "Senha Inválida" --text="Senha está em branco!\nVocê não terá acesso total as funções do programa!\nVocê tem certeza que deseja continuar mesmo assim?")
      if [ $? -eq 1 ]
        then
          getPasswordUser
      else
        :
      fi
  else
    userPassword=$(echo "$response" | cut -f1 -d "|")
  fi
}

setDistroUser()
{
  case $distro in
    "fedora")
      distros[fedora]=dnf
    ;;
    "ubuntu")
      distros[ubuntu]=apt
    ;;
    "arch linux")
      distros[arch linux]=pacman
    ;;
    "opensuse")
      distros[opensuse]=zypper
    ;;
    "gentoo")
      distros[gentoo]=portage
    ;;
    "centos")
      distros[centos]=yum
    ;;
    "slackware")
      distros[slackware]=pkgtools
    ;;
    "mageia")
      distros[mageia]=urpmi
    ;;
    *)
      zenity --warning --title="Sem suporte" --text="Distribuição linux não suportada no momento!"
    ;;
  esac
}

getInterfacesUser()
{
  #Get the interfaces avaliables on the computer and transform \n in ' '
  avaliableInterfaces=$(ip link | awk -F': ' '{print $2}' | tr '\n' ' ')

  for interface in $avaliableInterfaces
    do
      interfaces+=("" "$interface")
  done
}

autoUpgradeZenity()
{
  zenityUpgrade=$(zenity --question --title="Atualizar Programa?" --text="Programa pode estar desatualizado ou não.\nDeseja atualizar ou proceseguir?")
  if [ $? -eq 0 ]
    then
      echo $userPassword | sudo -S -u root "${distros[$distro]}" upgrade -y zenity
    if [ $? -eq 0 ]
      then
        zenity --info --text="Zenity foi atualizado com sucesso!"
    else
     zenity --error --text="Ocorreu um erro ao instalar $appName\nPossiveis causas:\n Senha incorreta ou em branco\n Nome errado/diferente do aplicativo"
    fi
  else
    :
  fi
}

main()
{

TermsConditions=$(zenity --text-info --title="Licença" --filename=$formatedDirectory --checkbox="Eu li e aceito os termos.")

if [ $? -eq 1 ]
then
  zenity --warning --title="Termos e Condições" --text="Termos e condições não aceitas!\nFechando programa!"
else
# Usuário clicou em "Eu li e aceito os termos"

  getPasswordUser
  
  autoUpgradeZenity

  menu()
  {
    while true; do
    OPCAO=$(zenity --list --width=1000 --height=700 --title "Gerenciador de Rede" --cancel-label "Cancelar" --ok-label "OK" --extra-button "Senha" --extra-button "Sobre" --column "Opção" --column "Descrição" \
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
  "Remover servidor DNS" "Remove o endereço do servidor DNS no arquivo de configuração" \
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

    if [ -z "$OPCAO" ]
      then
        exit 0
    fi
    
    #if [ "$OPCAO" == "Senha" ]
      #then
        #getPasswordUser
    #fi

    case $OPCAO in
      "Configurar nome da máquina")
        nomeHostname=$(hostname)
        setHostname=$(zenity --entry --title="Configurar nome da Máquina (Hostname)")

        if [ $nomeHostname != $setHostname ]
          then
            echo $userPassword | sudo -S -u root hostname $setHostname
            if [ $? -eq 0 ]
              then
                zenity --info --title "Hostname" --text="A troca de hostname para '$setHostname' foi um sucesso!"
            else
              zenity --error --text="Ocorreu um erro ao trocar o nome do hostname\nPossivel causa:\n Senha incorreta ou em branco"
            fi
        else
            zenity --warning --text="O novo nome não pode ser igual ao antigo nome!"
        fi
      ;;
      "Exibir nome da máquina")
        hostnameInfo=$(hostname)
        zenity --info --title "Informando o nome da Máquina (Hostname)" --text="O Nome da Máquina (Hostname) é $hostnameInfo."
      ;;
      "Configurar endereço IP")
        zenity --info --text="Você possui essas interfaces: \n $avaliableInterfaces"
        selecionado=$(zenity --list --width=550 --height=250 --title "Escolha a opção da interface que deseja configurar" --radiolist --column "Selecionado?" --column "Itens" "${interfaces[@]}" --separator=":")

        if [ $? -eq 0 ] && [ -n "$selecionado" ]
          then
            ipAdress=$(zenity --entry --title="Entre com o Endereço IP")
            netmask=$(zenity --entry --title="Entre com a sub-rede (Mascara de rede)")
            echo $userPassword | sudo -S -u root ifconfig $selecionado $ipAdress netmask $netmask up
        else
          echo "Nenhuma interface selecionada."
        fi
      ;;
      "Visualizar configurações de interfaces")
        interfaceConfig=$(ip addr)
        zenity --info --title "Visualização das Interfaces" --text="\n ${interfaceConfig}"
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
        zenity --info --text="Você possui essas interfaces: \n $avaliableInterfaces"
        selecionado=$(zenity --list --width=550 --height=250 --title "Escolha a opção da interface que deseja configurar" --radiolist --column "Selecionado?" --column "Itens" "${interfaces[@]}" --separator=":")

        if [ $? -eq 0 ] && [ -n "$selecionado" ]
          then
            echo $userPassword | sudo -S -u root ip link set $selecionado down
        else
          echo "Nenhuma interface selecionada."
        fi
      ;;
      "Ativar interface")
        zenity --info --text="Você possui essas interfaces: \n $avaliableInterfaces"
        selecionado=$(zenity --list --width=550 --height=250 --title "Escolha a opção da interface que deseja configurar" --radiolist --column "Selecionado?" --column "Itens" "${interfaces[@]}" --separator=":")

        if [ $? -eq 0 ] && [ -n "$selecionado" ]
          then
            echo $userPassword | sudo -S -u root ip link set $selecionado up
        else
          echo "Nenhuma interface selecionada."
        fi
      ;;
      "Renovar empréstimo DHCP")
      ;;
      "Gravar servidor DNS")
        servidorDns="/etc/resolv.conf"
        dns_server=$(zenity --entry --title="Adicionando servidor DNS" --text="Insira o endereço IP do servidor DNS:")
        #teste=$(echo "nameserver $dns_server" | sudo tee -a /etc/resolv.conf > /dev/null)
        echo $userPassword | sudo -S -u root sed -i '$ a nameserver '"$dns_server" $servidorDns
      ;;
      "Remover servidor DNS")
        servidorDns="/etc/resolv.conf"
        echo $userPassword | sudo -S -u root sed -i '$ d' $servidorDns
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
        userIP=$(zenity --entry --text "Digite o endereço IP:")
        userTTL=$(zenity --entry --text "Digite o valor TTL:")
        requerimentPing=$(ping -t $userTTL $userIP)
        zenity --info --title "Ping" --text="\n ${requirimentPing}"
      ;;
      "Pingar computador com tamanho")
      ;;
      "Instalar programa")
        appName=$(zenity --entry --text "Qual aplicativo deseja instalar?")
        echo $userPassword | sudo -S -u root "${distros[$distro]}" install -y $appName

        if [ $? -eq 0 ]
          then
            zenity --info --text="$appName foi instalado com sucesso!"
        else
          zenity --error --text="Ocorreu um erro ao instalar $appName\nPossiveis causas:\n Senha incorreta ou em branco\n Nome errado/diferente do aplicativo"
        fi
      ;;
      "Remover programa")
        appName=$(zenity --entry --text "Qual aplicativo deseja instalar?")
        echo $userPassword | sudo -S -u root "${distros[$distro]}" remove -y $appName

        if [ $? -eq 0 ]
          then
            zenity --info --text="$appName foi removido com sucesso!"
        else
          zenity --error --text="Ocorreu um erro ao remover $appName\nPossiveis causas:\n Senha incorreta ou em branco\n Nome errado/diferente do aplicativo"
        fi
      ;;
      "Sair")
        clear
        exit 0
      ;;
      "Senha")
        getPasswordUser
      ;;
      "Sobre")
        zenity --info --title "Informações" --text="Integrantes: Angelo e Janaina\nDisciplina: Sistemas Operacionais de Redes"
      ;;
      *)
        zenity --error --text="Opção inválida."
      ;;
    esac
  done
  }
  menu
fi
}

getDirectoryUser
getInterfacesUser
setDistroUser
main
