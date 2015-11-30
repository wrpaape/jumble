defmodule Jumble.LengthDict.Length21 do
  @length_21_length_dict %{"acceghlmoooorssstttyy" => ["cholecystogastrostomy"],
                           "aaacddeegillllnooopry" => ["palaeodendrologically"],
                           "aaccceeehiilllmnnottu" => ["mechanicointellectual"],
                           "aaabcegiilmmnnoorrstu" => ["membranocartilaginous"],
                           "aaabiinnnooprrssttttu" => ["protransubstantiation"],
                           "aaabegghilllnoooprssy" => ["glossolabiopharyngeal", "labioglossopharyngeal"],
                           "aceeghhimoooopprrrstt" => ["stereophotomicrograph"],
                           "accghhiillloooppssyyy" => ["psychophysiologically"],
                           "aaaccddeeeeehnorrssst" => ["tessarescaedecahedron"],
                           "acccefhiiiiilnoorsstt" => ["scientificohistorical"],
                           "abdeeghiiiilnnnsssstu" => ["indistinguishableness"],
                           "aaaceeghillmmnooprrty" => ["anemometrographically"],
                           "aeeeegghnnoooprrrstty" => ["stereoroentgenography"],
                           "aaabdeehiiilmnnrssstt" => ["disestablishmentarian"],
                           "cceehjjlmnoooossttuyy" => ["cholecystojejunostomy"],
                           "aadeegghnnnoooppprrty" => ["appendorontgenography"],
                           "ceghhiiiilloooopprssu" => ["philosophicoreligious"],
                           "accceiiilllmmooorrrty" => ["microcolorimetrically"],
                           "accceeeilllmnnorsstuy" => ["crystalloluminescence"],
                           "aabdeiillmnnooprsssuu" => ["mandibulosuspensorial"],
                           "aacghiillmnooooprsttt" => ["anthropoclimatologist"],
                           "aadeegghiilnnoopprtty" => ["pharyngoepiglottidean"],
                           "Paaabcdeehiilllmnorsu" => ["Pseudolamellibranchia"],
                           "aacceeiiilllllnstttuy" => ["intellectualistically"],
                           "aaccceeeinnnnoorrsstu" => ["counterreconnaissance"],
                           "aceeghiimmmoooprrrsst" => ["microseismometrograph"],
                           "aabceeghiiilnnnnortty" => ["noninterchangeability"],
                           "ccdddeehhlmnooooootuy" => ["duodenocholedochotomy"],
                           "aaccdehhillloooppstuy" => ["platydolichocephalous"],
                           "acceeimnnnnoooprrttuu" => ["counterpronunciamento"],
                           "aceeglmnooooorrssttty" => ["gastroenterocolostomy"],
                           "aaccegghhiiiloooprrst" => ["historicogeographical"],
                           "ccdeeehhlmnooooorstty" => ["choledochoenterostomy"],
                           "acghhhhilmooooopprrtt" => ["chromophotolithograph", "photochromolithograph"],
                           "aaacccceehhiilmmoprtu" => ["chemicopharmaceutical"],
                           "cceeghhhiiilnooopprty" => ["phoneticohieroglyphic"],
                           "aaaccgiiilmoorrstuuyz" => ["zygomaticoauricularis"],
                           "aaccceeehhhllnooorxxy" => ["hexachlorocyclohexane"],
                           "cceeeehhhmnooopprrsst" => ["thermophosphorescence"],
                           "aceeeiinnnooprrrttttu" => ["counterinterpretation"],
                           "aceeehiiilllmnooppsty" => ["poliencephalomyelitis"],
                           "aaciiiilnnnooosttttuz" => ["constitutionalization"],
                           "aacghhillmnooooopprrt" => ["anthropomorphological"],
                           "aaciiiilnnnoosstttttu" => ["anticonstitutionalist"],
                           "aacceeeeghhllnoopprrt" => ["electroencephalograph"],
                           "cceehhlmnooooprssttyy" => ["cholecystonephrostomy"],
                           "acceeilmoooprsstttuvy" => ["prostatovesiculectomy"],
                           "aacdeeeiiilllnnotttuz" => ["deintellectualization"],
                           "aabdeeehhllnnnopryyzz" => ["benzalphenylhydrazone"],
                           "aaabcccdeehilmoorstuy" => ["chlamydobacteriaceous"],
                           "cccdehiiiiloooorrsstt" => ["scleroticochoroiditis"],
                           "ccehhiilloooprsstttyy" => ["cholecystolithotripsy"],
                           "abdeeghiiilnnnsssstuu" => ["undistinguishableness"],
                           "aaaaccghiillmnooooptt" => ["anatomicopathological", "pathologicoanatomical"],
                           "aaabeehiiilmmnnrssstt" => ["establishmentarianism"],
                           "bceeeehiilmnnopprrssu" => ["superincomprehensible"],
                           "acchhhiiiiloooopprsst" => ["historicophilosophica"],
                           "aacdeeeehiiimnnnooptt" => ["aminoacetophenetidine"],
                           "ccdehhhiillooooprstty" => ["choledocholithotripsy"],
                           "aacdeghillnoooopprstu" => ["pseudoanthropological"],
                           "aaccdeghilmnnooooprry" => ["pharmacoendocrinology"],
                           "cceeehlmnoooorsstttyy" => ["enterocholecystostomy"],
                           "aaaeehilnnnooprrstttt" => ["heterotransplantation"],
                           "aaabeiiinnnorsstttttu" => ["transubstantiationite"],
                           "aabefiiilmnnorrrsttty" => ["intertransformability"],
                           "abdeeiilnnooopprrssst" => ["disproportionableness"],
                           "eeeehiilnoopprrrsttuy" => ["ureteropyelonephritis"],
                           "agghiillnnooooorrstty" => ["otorhinolaryngologist"],
                           "accdhimnoooorrssttyyy" => ["dacryocystorhinostomy"],
                           "aadeeeeehiilmmnnnptty" => ["pentamethylenediamine"],
                           "aacciillnooprrstttyyz" => ["cryptocrystallization"],
                           "adeeeeghinnoopprssstu" => ["pseudoparthenogenesis"],
                           "aaccddeeemnnoooprttuy" => ["duodenopancreatectomy", "pancreatoduodenectomy"],
                           "abchiiilloooooppstttu" => ["poluphloisboiotatotic"],
                           "aacdeeehhillnnprtyyyz" => ["acetylphenylhydrazine"],
                           "accdehhhiiillmooppssy" => ["hypsidolichocephalism"],
                           "addeehhiimmoopprrsstu" => ["pseudohermaphroditism"],
                           "aadeiiiilnnoorrsttuvz" => ["overindustrialization"]}
  
  def get(string_id) do
    @length_21_length_dict
    |> Map.get(string_id)
  end
end
