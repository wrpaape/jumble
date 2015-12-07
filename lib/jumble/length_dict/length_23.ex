defmodule Jumble.LengthDict.Length23 do
  def get(string_id) do
    %{"Paaaabcdeehiilllmnorstu" => ["Pseudolamellibranchiata"],
      "aaaabiiilnnnorssstttttu" => ["transubstantiationalist"],
      "aaaaccchhhiimnnorrrssty" => ["macracanthrorhynchiasis"],
      "aaabcdeeehiilllmnoprstu" => ["pseudolamellibranchiate"],
      "aaaeegimnnoooorrssssttt" => ["gastroenteroanastomosis"],
      "aaccceefgghiiiilnooprst" => ["scientificogeographical"],
      "aaccddeeimnnooooprsttuy" => ["pancreaticoduodenostomy"],
      "aaccgghhiiilllooooopstt" => ["pathologicohistological"],
      "aacddeeiiiiiimnoprrsstt" => ["pericardiomediastinitis"],
      "aacghhilllmnooooopprrty" => ["anthropomorphologically"],
      "abcceeehhilmnoopprrstty" => ["blepharosphincterectomy"],
      "acceghhhiiillloooooppst" => ["philosophicotheological"],
      "acddeefhhilllmooprsuxyy" => ["formaldehydesulphoxylic"],
      "aceeeehhmmoooopprrstttt" => ["hematospectrophotometer"],
      "aeeehhhhilllnnnoopppstu" => ["phenolsulphonephthalein"],
      "aeehhhhilllmnnooppsttuy" => ["thymolsulphonephthalein"],
      "cdddeeeeefiimmnooprttyy" => ["epididymodeferentectomy"]}
    |> Map.get(string_id)
  end
end
