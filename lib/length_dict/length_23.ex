defmodule LengthDict.Length23 do
  @length_23_length_dict %{'Paaaabcdeehiilllmnorstu' => ["Pseudolamellibranchiata"], 'aaaabiiilnnnorssstttttu' => ["transubstantiationalist"], 'aaaaccchhhiimnnorrrssty' => ["macracanthrorhynchiasis"], 'aaabcdeeehiilllmnoprstu' => ["pseudolamellibranchiate"], 'aaaeegimnnoooorrssssttt' => ["gastroenteroanastomosis"], 'aaccceefgghiiiilnooprst' => ["scientificogeographical"], 'aaccddeeimnnooooprsttuy' => ["pancreaticoduodenostomy"], 'aaccgghhiiilllooooopstt' => ["pathologicohistological"], 'aacddeeiiiiiimnoprrsstt' => ["pericardiomediastinitis"], 'aacghhilllmnooooopprrty' => ["anthropomorphologically"], 'abcceeehhilmnoopprrstty' => ["blepharosphincterectomy"], 'acceghhhiiillloooooppst' => ["philosophicotheological"], 'acddeefhhilllmooprsuxyy' => ["formaldehydesulphoxylic"], 'aceeeehhmmoooopprrstttt' => ["hematospectrophotometer"], 'aeeehhhhilllnnnoopppstu' => ["phenolsulphonephthalein"], 'aeehhhhilllmnnooppsttuy' => ["thymolsulphonephthalein"], 'cdddeeeeefiimmnooprttyy' => ["epididymodeferentectomy"]}
  
  def get(string_id) do
    @length_23_length_dict
    |> Map.get(string_id)
  end
end
