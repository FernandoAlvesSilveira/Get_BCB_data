#Carrega os pacotes necessários
library(tidyverse)
library(lubridate)
library(jsonlite)
library(writexl)

#Cria um vetor para armazenar as séries desejadas
Cod_Serie <- c(22099, #PIB trimestral - Dados observados - Produto Interno Bruto a preços de mercado
               22083, #PIB trimestral - Dados observados - Agropecuária (total) SCN 2010
               22084, #PIB trimestral - Dados observados - Indústria (total)
               22089 #PIB trimestral - Dados observados - Serviços (total) 
)
#Cria um vetor para armazenar os nomes atribuiídos das variáveis (séries)
Nome_Serie <- c("PIB_tri",  #PIB trimestral - Dados observados - Produto Interno Bruto a preços de mercado
                "PIB_agro", #PIB trimestral - Dados observados - Produto Interno Bruto a preços de mercado
                "PIB_ind",  #PIB trimestral - Dados observados - Indústria (total)
                "PIB_ser"   #PIB trimestral - Dados observados - Serviços (total) 
)

#Nomeia o objeto series como um vetor do tipo list
series <- vector(mode = "list")


#Laço que acessa o site do bcb, passando como parâmetro cada variável desejada, para então armazenar cada série temporal no objeto séries 
for (i in 1:length(Cod_Serie)) {
  url = paste0('https://api.bcb.gov.br/dados/serie/bcdata.sgs.',Cod_Serie,'/dados?formato=json')
  series[[i]] = fromJSON(url[i])
  #Nomeia as variaveis com os nomes do vetor Nome_Serie
  names(series[[i]])[names(series[[i]]) =="valor"] = Nome_Serie[i] 
  
}

#armazena os dados um data frame
t_df <- as.data.frame(series)

#armazena a coluna data em um data frame
t_df_data <- t_df %>% select(data)

#armazena somente as colunas das variaveis selecionadas no vetor Nome_Serie
t_df <- t_df %>% select(Nome_Serie)

#une os data frames adicionando as colunas das variaveis ao data frame com a coluna data
t_df_data <- t_df_data %>% add_column(t_df)

#armazena o data frame em um novo data frame para ser exportado
df <- t_df_data

#Exporta o data frame em formato csv 
write.csv2(df, file="dados_bcb", row.names=F)

#Exporta o data frame em formato xlsx
pasta <- getwd()
local <- paste0(local,'/dados_bcb.xlsx')
write_xlsx(df,local)
