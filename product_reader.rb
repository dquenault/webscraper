require 'mechanize'

inputFile = "input.txt"
outputFile = "output.txt"
delimiter = "|"

def getDescription(product)
    
    mechanize = Mechanize.new
 
    page = mechanize.get('https://groceries.morrisons.com/webshop/startWebshop.do')
    form = page.forms_with(class: 'suggestionsForm')
    
    form[0].field_with(:id => 'findText').value = product
    resultsPage = form[0].submit

    productLink = resultsPage.search("h4.productTitle").at_css("a")['href']
    productDetailPage = resultsPage.link_with(:href => productLink).click
    
    description  = ""
    productDetailPage.at_xpath('//div[@id="bopBottom"]').at_css('div.bopSection').css('p').each { |e| description = description + e.to_html }
    return description
 
end

def webscrape(inputFile, outputFile, delimiter)
  inputFile = File.open(inputFile,'r').read
  outputFile = File.open(outputFile, 'w')

  inputFile.each_line do |productNumber|
    description = getDescription(productNumber.strip)
    outputFile.puts productNumber.strip + delimiter + description
  end
end

webscrape(inputFile,outputFile, delimiter)