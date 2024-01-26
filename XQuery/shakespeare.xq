let $collection := collection("db/shakespeare")

(: 20 :)
(:
return <wynik>
  {
    for $play in $collection//PLAY
    return <TITLE>{$play/TITLE/text()}</TITLE>
  }
  </wynik>
:)

(: 21 :)
(:
for $plays in $collection//PLAY[.//LINE[contains(., "or not to be")]]
  return <TITLE> {$plays/TITLE/text()} </TITLE>
:)

(: 22 :)
for $plays in $collection//PLAY
  return <wynik>
      {
        <sztuka tytul="{$plays/TITLE/text()}">
          <postaci>{count($plays//PERSONA)}</postaci>
          <aktow>{count($plays//ACT)}</aktow>
          <scen>{count($plays//SCENE)}</scen>
        </sztuka>
      }
    </wynik>