defmodule Jumble.ScowlDict.Size80.Length23 do
  def get(string_id) do
    %{"aaaabeehiiilmnnnrsssttt" => ["antiestablishmentarians"],
      "aaaabiiilnnnorssstttttu" => ["transubstantiationalist"],
      "aaccceeeeghhillnoopprrt" => ["electroencephalographic"],
      "aacceeeeeghhllnoopprrrt" => ["electroencephalographer"],
      "aaceeeiiilllnnoortttuvz" => ["overintellectualization"],
      "aadeiiiiilnnnoossttttuz" => ["deinstitutionalizations"],
      "aaeeeeeehhilmmnnrstttxy" => ["hexamethylenetetramines"],
      "aaeeeiilmnnnnooprrssstt" => ["nonrepresentationalisms"],
      "aaeiiiiilnnnoorssttttuz" => ["reinstitutionalizations"],
      "abbeeiiiiilnrssstttttuu" => ["intersubstitutabilities"],
      "abccdfhhllnoooooorrrruy" => ["hydrochlorofluorocarbon"],
      "abcceeehllllmoorsstuxyy" => ["carboxymethylcelluloses"],
      "abdeeeghiiiilnnnssssstu" => ["indistinguishablenesses"],
      "abdeeeiilnnooopprrsssst" => ["disproportionablenesses"],
      "acddeefhhiillmnoooorrtu" => ["dichlorodifluoromethane"],
      "ccceehiimmoooopprrrsttt" => ["microspectrophotometric"],
      "cceeehimmoooopprrrssttt" => ["microspectrophotometers"],
      "ceeghiilmmnnooooprssuuy" => ["psychoneuroimmunologies"],
      "ceghiilmmnnooooprsstuuy" => ["psychoneuroimmunologist"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaaabeehiiilmnnnrsssttt", "aaaabiiilnnnorssstttttu",
     "aaccceeeeghhillnoopprrt", "aacceeeeeghhllnoopprrrt",
     "aaceeeiiilllnnoortttuvz", "aadeiiiiilnnnoossttttuz",
     "aaeeeeeehhilmmnnrstttxy", "aaeeeiilmnnnnooprrssstt",
     "aaeiiiiilnnnoorssttttuz", "abbeeiiiiilnrssstttttuu",
     "abccdfhhllnoooooorrrruy", "abcceeehllllmoorsstuxyy",
     "abdeeeghiiiilnnnssssstu", "abdeeeiilnnooopprrsssst",
     "acddeefhhiillmnoooorrtu", "ccceehiimmoooopprrrsttt",
     "cceeehimmoooopprrrssttt", "ceeghiilmmnnooooprssuuy",
     "ceghiilmmnnooooprsstuuy"]
    |> Enum.into(HashSet.new)
  end
end
