(:
for $k in doc('file:///C:/Kacper/Desktop/ZTPD/XPath-XSLT/swiat.xml')/SWIAT/KONTYNENTY/KONTYNENT
return <KRAJ>
    {$k/NAZWA, $k/STOLICA}
</KRAJ>
:)

(:
for $k in doc('file:///C:/Kacper/Desktop/ZTPD/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ
return <KRAJ>
    {$k/NAZWA, $k/STOLICA}
</KRAJ>
:)

(:
for $k in doc('file:///C:/Kacper/Desktop/ZTPD/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ
where starts-with($k/NAZWA, 'A')
return <KRAJ>
    {$k/NAZWA, $k/STOLICA}
</KRAJ>
:)

(:
for $k in doc('file:///C:/Kacper/Desktop/ZTPD/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ
where starts-with($k/NAZWA, substring($k/STOLICA, 0, 2))
return <KRAJ>
    {$k/NAZWA, $k/STOLICA}
</KRAJ>
:)

(:
doc('file:///C:/Kacper/Desktop/ZTPD/XPath-XSLT/swiat.xml')//KRAJ
:)

(:
doc('file:///C:/Kacper/Desktop/ZTPD/XPath-XSLT/zesp_prac.xml')
:)

(:
for $k in doc('file:///C:/Kacper/Desktop/ZTPD/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW/PRACOWNICY/ROW
return $k/NAZWISKO
:)

(:
for $k in doc('file:///C:/Kacper/Desktop/ZTPD/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW[NAZWA = 'SYSTEMY EKSPERCKIE']/PRACOWNICY/ROW
return $k/NAZWISKO
:)

(:
for $k in count(doc('file:///C:/Kacper/Desktop/ZTPD/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW[ID_ZESP = 10]/PRACOWNICY/ROW)
return $k
:)

(:
for $k in doc('file:///C:/Kacper/Desktop/ZTPD/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW/PRACOWNICY/ROW[ID_SZEFA = 100]
return $k/NAZWISKO
:)

(:
let $k := doc('file:///C:/Kacper/Desktop/ZTPD/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW/PRACOWNICY/ROW[ID_ZESP = /ZESPOLY/ROW/PRACOWNICY/ROW[NAZWISKO = 'BRZEZINSKI']/ID_ZESP]
return sum($k/PLACA_POD)
:)