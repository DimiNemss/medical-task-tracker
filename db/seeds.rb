system_tags = [
  "отчетность",
  "операции",
  "звонок"
]

system_tags.each do |tag_name|
  Tag.find_or_create_by!(name: tag_name) do |tag|
    tag.system = true
  end
end