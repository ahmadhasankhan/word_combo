json.data do
  json.array! @dictionaries.each{|d| d}
end