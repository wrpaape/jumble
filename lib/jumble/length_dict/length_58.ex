defmodule Jumble.LengthDict.Length58 do
  def get(string_id) do
    %{"Laaabccdefggggggghhiiillllllllllnnnnooooooprrrrstwwwwyyyyy" => ["Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch"]}
    |> Map.get(string_id)
  end
end
