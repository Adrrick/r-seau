# Exploration de l'OS et du matériel

## Sujet 2 : Débugger et désassembler des programmes compilés

### Hello world

Le programme :

```
#include <stdio.h>

int main(void)
{
    printf("Hello World!\n");
    return 0;
}

```

Le "Hello World!" dans le .exe avec ghidra :

```
                             .rdata                                          XREF[1]:     _main:0040135e(*)  
        00403024 48 65 6c        ds         "Hello World!"
                 6c 6f 20 
                 57 6f 72 
        00403031 00              ??         00h
        00403032 00              ??         00h
        00403033 00              ??         00h
```


### Winrar version payée (eheh boiiii)

Alors j'ai suivi un tuto (https://www.youtube.com/watch?v=S1UHBeJP-Eg).  
Il m'a fait utiliser xdbg, un débugger Windows propre et avec une interface agréable.  

Pour résumer, j'ai ouvert winrar.exe dans xdbg et j'ai modifié une ligne en rapport à la clé d'activation de la version payante de Winrar.  
C'était un jump vers le message comme quoi j'ai une version d'essai et que ça serait sympa de payer.  
Donc j'ai remplacé cette ligne par un NOP, donc pas de jump, donc Winrar croit que j'ai une version payante.  

Ca donne un bel écran "About" dans lequel il y a écrit que ma version de Winrar est activée, mais ma licence est inexistante (vu que j'en ai pas, c'est logique) donc ça fait un gros vide.  

Du coup plus de "Achète mon produit steuplait", juste le logiciel. Youpi !  

![](https://i.imgur.com/jXsX0SO.png)