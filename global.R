# Analyse texts from the whatsapp group wasanii
library(rwhatsapp)
library(tidyverse)
library(lubridate)
library(tidytext)
library(ggimage)
library(stopwords)
library(magrittr)
library(plotly)
library(RColorBrewer)
library(GISTools)

# read in the chat to R:
chat <- rwa_read(x = "WhatsApp Chat with Wasanii.txt") |> 
  as_tibble()

# chat

# There are some messages whose author is "NA". These are the ones sent by 
# whatsapp eg. this chat is end to end encrypted bla bla bla.
# Filter those out & remove the column "source" since it's not helpful:
chat <- chat |> filter(!is.na(author)) |> dplyr::select(-source)


# To get the date alone from the date time "time" in base R I'd do something like:
# end_time %>% format("%Y-%m-%d")

# but lubridate's date seems clean:
# date(end_time)

# Get date alone & relocate day to be after time:
chat <- chat |> mutate(day = lubridate::date(time)) |> relocate(day, .after = time)

# Sometime back Joy & Rachael used different numbers. Add the count of those to 
# their names:
chat <- chat |> 
  mutate(
    author = as.character(author), 
    author = dplyr::case_when(author %in% "+254 717 342303" ~ "Joy Kanyi", 
                              author %in% "+254 722 350002" ~ "Rachael Kanini", 
                              TRUE ~ author), 
    author = dplyr::case_when(
      author %in% "Joy Kanyi" ~ "Joy", 
      author %in% "Rachael Kanini" ~ "Rachael", 
      author %in% "Lillian Ayoo" ~ "Ayoo", 
      author %in% "Mwavu Kennedy" ~ "Mwavu", 
      TRUE ~ author
    )
  )

# When is the start of the chat from the data?
chatStart <- chat$time |> min()
chatEnd <- chat$time |> max()

# Texts per day bar chart:
textsPerDayData <- chat |> count(day)
textsPerDayBars <- textsPerDayData |> 
  plot_ly(x = ~ day, y = ~ n, type = "bar", 
          hoverinfo = "text", 
          text = ~ paste0("</br>", day, "</br>", n, " texts")
          ) |> 
  layout(
    yaxis = list(title = "Number of texts"), 
    xaxis = list(title = "Day")
  )

# Day with highest number of texts so far:
dayWithMostTexts <- textsPerDayData |> 
  dplyr::slice_max(order_by = n, n = 1)

# Monthly analyses:
monthlyTextsPerPerson <- chat |> 
  dplyr::select(-time) |> 
  mutate(month = day |> format("%Y-%m")) |> 
  count(month, author)


allMonthsnAuthors <- monthlyTextsPerPerson |> expand(month, author)

monthsAuthorsCount <- monthlyTextsPerPerson |> 
  right_join(allMonthsnAuthors) |> 
  replace_na(list(n = 0))


textsPerMonthLineChart <- monthsAuthorsCount |> 
  plot_ly(x = ~ month, y = ~ n, color = ~ author, type = "scatter", 
          mode = "lines+markers", 
          hoverinfo = "text", 
          text = ~ paste0(author, ": ", n, " texts")
          ) |> 
  layout(
    hovermode = "x unified", 
    legend = list(
      orientation = "h", xanchor = "center", x = 0.5, y = -0.2
    ), 
    xaxis = list(title = ""), 
    yaxis = list(title = "Number of texts")
  )



# So who's sent what ratio of the messages? Find out.
textsPerPersonData <- chat |> count(author) |> 
  mutate(author = reorder(author, n), 
         Percentage = round(n / sum(n) * 100, digits = 1)
         )

pal <- brewer.pal(n = nrow(textsPerPersonData), name = "Dark2") |> 
  setNames(textsPerPersonData$author)

totalTextsPerPerson <- textsPerPersonData |> 
  plot_ly(x = ~ n, y = ~ author, type = "bar", color = ~ author, 
          colors = pal, 
          hoverinfo = "text", 
          text = ~ paste0(n, " texts")
          ) |> 
  layout(
    yaxis = list(title = ""), 
    xaxis = list(title = ""), 
    legend = list(orientation = "h", xanchor = "center", x = 0.5, y = -0.1, 
                  traceorder = "normal"
                  )
  )

# Who has had the max number of texts?
whoMaxTexts <- textsPerPersonData |> slice_max(order_by = n)

# Who has had the least number of texts?
whoMinTexts <- textsPerPersonData |> slice_min(order_by = n)

otherTotalTexts <- textsPerPersonData |> arrange(n) |> 
  slice(-c(1, n())) |> 
  summarise(
    totalTexts = sum(n), 
    Percent = sum(Percentage) |> paste0("%")
  )

textRatioPerPerson <- textsPerPersonData |> 
  mutate(author = reorder(author, -Percentage)) |> 
  plot_ly(y = ~ "A", x = ~ Percentage, name = ~ author, color = ~ author, 
          hoverinfo = "text", 
          text = ~ paste0("</br>", author, "</br>", Percentage, "%")
  ) |> 
  add_bars(width = 0.4) |> 
  layout(barmode = "stack", 
         xaxis = list(ticksuffix = "%", zerolinecolor = "#ffff", title = ""), 
         yaxis = list(showticklabels = FALSE, title = ""), 
         legend = list(orientation = "h", xanchor = "center", x = 0.5, 
                       traceorder = "normal"
                       )
  )



# Let's find out what people's favorite emojis are and this is where 
# tidyr comes in

emoji_data <- rwhatsapp::emojis %>% # data built into package
  mutate(hex_runes1 = gsub("\\s.*", "", hex_runes)) %>% # ignore combined emojis
  mutate(emoji_url = paste0("https://abs.twimg.com/emoji/v2/72x72/", 
                            tolower(hex_runes1), ".png"))



# Ayoo emojis:

# Distinct people in group:
ourNames <- textsPerPersonData$author |> as.character()

emoji_f <- function(topn = 5, chat) {
  emojiCountPlotList <- vector(mode = "list", length = length(ourNames))
  names(emojiCountPlotList) <- ourNames
  
  for (name in ourNames) {
    emojiPlot <- chat %>%
      unnest(emoji) %>%
      count(author, emoji, sort = TRUE) %>%
      group_by(author) %>%
      slice_max(order_by = n, n = topn) %>%
      left_join(emoji_data, by = "emoji") %>% 
      filter(author == !!name) |> 
      mutate(emoji = reorder(emoji, n)) |> 
      plot_ly(x = ~ n, y = ~ emoji, type = "bar", color = ~ emoji, 
              hoverinfo = "text", 
              text = ~ paste0(n)
      ) |> 
      add_text(x = ~ n + 5, text = ~ emoji, hovertext = ~ name, size = I(20), 
               textposition = 'right') |> 
      layout(
        yaxis = list(showticklabels = FALSE, title = "Top 5 emojis"), 
        xaxis = list(title = ""), 
        showlegend = FALSE
      )
    
    emojiCountPlotList[[name]] <- emojiPlot
  }
  
  emojiCountPlotList
}
# emojiCountPlotList$Ayoo
# emojiCountPlotList$Joy
# emojiCountPlotList$Rachael

# Niiicceee!

# Looks like all of us like face with tears of joy

# Let's compare the fav words


# Get rid of stop words first (english & swahili)
# and 'omitted' and 'media'
swahili <- c('ni', 'na', 'mimi', 'ya', 'can', 'ama', 'kama',
             'ata', 'eeee', 'students.uonbi.ac.ke', 'tu', 'ata', 'yeah', 'si', 
             'kwa', 'hii', 'sawa', 'tu', 'just', 'ah', 'kwani', 'ndio', 'za', 'ndio', 
             'like', 'za', 'iko', 'bado', 'huwa', 'ee', 'mi', 'zii', 'hata', 'niko', 
             'ndio', 'iko', 'kuna', 'yangu', 'za', 'bado', 'hiyo', 'sasa', 
             'yes', 'lakini', 'hapa', 'wacha', 'ooh', 'uko', 'good', 'ka', 'pia', 
             'kitu', 'juu', 'https', 'eeh', 'say', 'ati', 'juu', 'wewe', 'coz', 
             'cause', 'eee', 'aje', 'oh', 'morning', 'nilikuwa', '2020', 'watu', 
             'mtu'
             )
to_remove <- c(stopwords(), swahili, 
               'media', 'omitted', 'okay', 'think', 
               'opportunitiesforyoungkenyans.co.ke', 'really', 'one', 'first', 'though',
               'eeeh', 'aki', 'hizo', 'mbona', 'know', 'ebu', 'alafu'
               )



top_words <- function(topn = 15, chat) {
  # Top n words chart:
  wordCountPlotList <- vector(mode = "list", length(ourNames))
  names(wordCountPlotList) <- ourNames
  
  for (name in ourNames) {
    wordPlot <- chat %>%
      unnest_tokens(input = text,
                    output = word) %>%
      filter(!word %in% to_remove) %>%
      count(author, word, sort = TRUE) %>%
      group_by(author) %>% 
      top_n(n = 15, n) |> 
      filter(author == !!name) |> 
      mutate(word = reorder(word, n)) |> 
      plot_ly(x = ~ n, y = ~ word, color = ~ word, type = "bar", 
              hoverinfo = "text", 
              text = ~ paste0(n)
      ) |> 
      layout(
        showlegend = FALSE, 
        yaxis = list(title = ""), 
        xaxis = list(title = "Count")
      )
    
    wordCountPlotList[[name]] <- wordPlot
  }
  
  wordCountPlotList
}

# wordCountPlotList$Ayoo
# wordCountPlotList$Joy

