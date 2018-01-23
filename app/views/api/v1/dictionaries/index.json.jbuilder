json.data do
  json.array! @dictionaries.collect { |d| d.word }
end

