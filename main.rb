require 'rubygems'
require 'zlib'
require 'nokogiri'
require 'csv'
require 'open-uri'
require 'net/http'
require 'byebug'


url = "http://www.casamineira.com.br/imovel/aluguel/apartamento-para-alugar-no-buritis-100m2-RS1800/AP0"


all_real_state_hashs = []
all_real_state_arrays = []
(0..100).each do |n|
  begin

    if(n < 10)
      n = "00" + n.to_s
    elsif(n >= 10 && n < 100)
      n = "0" + n.to_s
    end
    doc = Nokogiri::HTML(open(url + n))

    # Titulo e preco
    full_title = doc.css(".tituloRealty")
    title, price = full_title[0].text.split('»')

    # Demais info
    info = doc.css(".pinfo li strong")

    real_state_info = Hash.new
    real_state_info["codigo"] = n

    real_state_info["area"] = info[0].text.strip
    real_state_info["quartos"] = info[1].text.strip
    real_state_info["banheiros"] = info[2].text.strip
    real_state_info["suites"] = info[3].text.strip
    real_state_info["vagas"] = info[4].text.strip
    real_state_info["condominio"] = info[5].text.strip
    real_state_info["endereco"] = info[6].text.strip
    real_state_info["IPTU"] = info[7].text.strip


    real_state_info["titulo"] = title.strip
    real_state_info["preco"] = price.strip

    all_real_state_hashs << real_state_info
    all_real_state_arrays << real_state_info.map do |k,v|
      v
    end

  rescue => e
    p e
    p "Nao foi encontrado ap com #{n}"
    next
  end
end


CSV.open("output.csv", "wb") do |csv|
  csv << ["Codigo",
          "Area",
          "Quartos",
          "Banheiros",
          "Suites",
          "Vagas",
          "Condominio",
          "Endereco",
          "IPTU",
          "Titulo",
          "Preco"]
  all_real_state_arrays.each do |s|
    csv << s
  end
end
