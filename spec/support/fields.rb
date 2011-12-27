def field_should_have(field, text)
  page.should have_xpath(".//input[@id='#{field}' and @value='#{text}']")
end
