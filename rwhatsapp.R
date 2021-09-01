# I am going to analyse texts from the whatsapp group wasanii

library(rwhatsapp)
library(tidyverse)
library(lubridate)
library(tidytext)
library(ggimage)
library(stopwords)
library(magrittr)
library(RColorBrewer)
library(GISTools)

# read in the chat to R:
chat <- rwa_read(
  x = "C:\\Users\\kenmw\\OneDrive\\Documents\\Programming\\Datasets\\WhatsApp Chat with Wasanii.txt"
)

# View the chat:
# View(chat)

is.data.frame(chat)

# convert to tibble:
chat <- as_tibble(chat)
chat

# There are some messages who author is "NA". These are the ones sent by whatsapp eg.
# this chat is end to end encrypted bla bla bla.
# We filter those out:
chat <- chat |> filter(!is.na(author))

# View(chat)

# There is also a column called "source" which shows the path to the txt file, not
# sure if that's important
# ----------------------------------
chat <- chat |> dplyr::select(-source)
# ----------------------------------

# Over how much time did we manage to accumulate those 5799 messages?

# analytic way:
# first text i have was sent on:
start_time <- min(chat$time)

# and the last text on:
end_time <- max(chat$time)

# time difference of:
end_time - start_time
# around 329 days

# A ggplot of messages per day would do us good. For that i need the day each 
# message was sent.

# To get the date alone from the date time "time" in base R i'd do something like:
end_time %>% format("%Y-%m-%d")

# but lubridate's date seems clean:
date(end_time)

# Get date alone & relocate day to be after time:
chat <- chat |> mutate(day = date(time)) |> relocate(day, .after = time)


# Okay now the graph:
windows(13, 10)

# chat %>% 
#   count(day) %>% 
#   ggplot(mapping = aes(x = day, y = n)) + 
#   geom_col(width = 0.6) + 
#   ggtitle("Total messages per day") + 
#   xlab("") + ylab("") + 
#   theme_classic() + 
#   
#   scale_x_date(date_breaks = "1 month", date_labels = "%b %Y") + 
#   theme(
#     aspect.ratio = 0.7, 
#     axis.text.x = element_text(angle = 90, hjust = 1), 
#     plot.title = element_text(hjust = 0.5)
#   )

library(plotly)
textsPerDay <- chat |> count(day) |> 
  plot_ly(x = ~ day, y = ~ n, type = "bar", 
          hoverinfo = "text", 
          text = ~ paste0("</br>", day, "</br>", n, " texts")
          ) |> 
  layout(
    yaxis = list(title = "Number of texts"), 
    xaxis = list(title = "Day")
  )

# Interpretation:
# The days where the chats shoot up to over 50 messages were the days we had either 
# a CAT or an exam and yunno...
# There is also a period btwn Jan and Feb where the chats are at their highest for 
# a while. Those were the 2 exam weeks for 3.1
# The last day also has relatively high number of messages. That was yesterday and we
# had a CAT.


# So who's sent what ratio of the messages? Find out.
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

# chat %>% 
#   count(author) %>% 
#   ggplot(mapping = aes(x = reorder(author, n), y = n)) + 
#   geom_bar(stat = "identity") + 
#   ggtitle("Number of messages per person") + 
#   xlab("") + ylab("") + 
#   theme_classic() + 
#   coord_flip()

textsPerPersonData <- chat |> count(author) |> 
  mutate(author = reorder(author, n), 
         Percentage = round(n / sum(n) * 100, digits = 1)
         )

textsPerPerson <- textsPerPersonData |> 
  plot_ly(x = ~ n, y = ~ author, type = "bar", 
          hoverinfo = "text", 
          text = ~ paste0(n, " texts")
          ) |> 
  layout(
    yaxis = list(title = ""), 
    xaxis = list(title = "Number of texts")
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
         legend = list(orientation = "h", xanchor = "center", x = 0.5)
  )



# Let's find out what people's favorite emojis are and this is where 
# tidyr comes in

emoji_data <- rwhatsapp::emojis %>% # data built into package
  mutate(hex_runes1 = gsub("\\s.*", "", hex_runes)) %>% # ignore combined emojis
  mutate(emoji_url = paste0("https://abs.twimg.com/emoji/v2/72x72/", 
                            tolower(hex_runes1), ".png"))

chat %>%
  unnest(emoji) %>%
  count(author, emoji, sort = TRUE) %>%
  group_by(author) %>%
  top_n(n = 5, n) %>%
  left_join(emoji_data, by = "emoji") %>% 
  filter(author == "Ayoo") |> 
  ggplot(aes(x = reorder(emoji, n), y = n, fill = author)) +
  geom_col(show.legend = FALSE) +
  ylab("") + xlab("") + 
  coord_flip() +
  geom_image(aes(y = n + 20, image = emoji_url)) +
  # facet_wrap(~author, ncol = 2, scales = "free_y") +
  ggtitle("Frequently used emojis") + 
  theme_classic() + 
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank(), 
        aspect.ratio = 0.6, 
        plot.title = element_text(hjust = 0.5))

# Ayoo emojis:
chat %>%
  unnest(emoji) %>%
  count(author, emoji, sort = TRUE) %>%
  group_by(author) %>%
  top_n(n = 5, n) %>%
  left_join(emoji_data, by = "emoji") %>% 
  filter(author == "Ayoo") |> 
  mutate(emoji = reorder(emoji, n)) |> 
  plot_ly(x = ~ n, y = ~ emoji, type = "bar", color = ~ emoji, 
          hoverinfo = "text", 
          text = ~ paste0(n)
          ) |> 
  add_text(text = ~ emoji, hovertext = ~ name, size = I(20), 
           textposition = 'middle right') |> 
  layout(
    yaxis = list(showticklabels = FALSE, title = "Top 5 emojis"), 
    xaxis = list(title = ""), 
    showlegend = FALSE
  )

# Distinct people in group:
ourNames <- textsPerPersonData$author |> as.character()

emojiCountPlotList <- vector(mode = "list", length = length(ourNames))
names(emojiCountPlotList) <- ourNames

for (name in ourNames) {
  emojiPlot <- chat %>%
    unnest(emoji) %>%
    count(author, emoji, sort = TRUE) %>%
    group_by(author) %>%
    top_n(n = 5, n) %>%
    left_join(emoji_data, by = "emoji") %>% 
    filter(author == !!name) |> 
    mutate(emoji = reorder(emoji, n)) |> 
    plot_ly(x = ~ n, y = ~ emoji, type = "bar", color = ~ emoji, 
            hoverinfo = "text", 
            text = ~ paste0(n)
    ) |> 
    add_text(text = ~ emoji, hovertext = ~ name, size = I(20), 
             textposition = 'middle right') |> 
    layout(
      yaxis = list(showticklabels = FALSE, title = "Top 5 emojis"), 
      xaxis = list(title = ""), 
      showlegend = FALSE
    )
  
  emojiCountPlotList[[name]] <- emojiPlot
}

# emojiCountPlotList$Ayoo
# emojiCountPlotList$Joy
# emojiCountPlotList$Rachael

# Niiicceee!

# Looks like all of us like face with tears of joy

# Let's compare the fav words
chat %>%
  unnest_tokens(input = text,
                output = word) %>%
  count(author, word, sort = TRUE) %>%
  group_by(author) %>%
  top_n(n = 6, n) %>%
  ggplot(aes(x = reorder_within(word, n, author), y = n, fill = author)) +
  geom_col(show.legend = FALSE) +
  ylab("") +
  xlab("") +
  coord_flip() +
  facet_wrap(~author, ncol = 2, scales = "free_y") +
  scale_x_reordered() +
  ggtitle("Most often used words")

# Those just stop words, let's get rid of them. And also some swahili stopwords
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

chat %>%
  unnest_tokens(input = text,
                output = word) %>%
  filter(!word %in% to_remove) %>%
  count(author, word, sort = TRUE) %>%
  group_by(author) %>%
  top_n(n = 15, n) %>%
  ggplot(aes(x = reorder_within(word, n, author), y = n, fill = author)) +
  geom_col(show.legend = FALSE, width = 0.7) +
  ylab("") +
  xlab("") +
  theme_classic() + 
  coord_flip() +
  facet_wrap(~author, ncol = 2, scales = "free_y") +
  scale_x_reordered() +
  ggtitle("Frequently used words") + 
  theme(
    aspect.ratio = 0.8, 
    plot.title = element_text(hjust = 0.5)
  )

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

# wordCountPlotList$Ayoo
# wordCountPlotList$Joy

# Joy must have been the most attentive in Judy's class and the big words 
# reflect that. Seems to be more worried about the economy.

# Ayoo is our plug that's why we all say her name a lot. She is mostly worried 
# about our whereabouts esp. before a CAT or exam that's why 'ako?' is on top of
# her list. Abdalla seems to be her trusted source. 

# Mwavu seems to be doing nothing much apart from calling Ayoo and asking for 
# answers. May the good Lord be with him.

# Nelvine is money. Money is Nelvine. Idk if that's the central bank she was talking
# about and what connection she has there. She's also more appreciative of the 
# group's work.

# Saved the best for the last. Mostly asking what the answer to a certain number 
# is, i mean we all do but our pal is putting a lot of effort into it. She's 
# mostly worried about class, notes and CATs. That's expected as 3rd year was/is
# her year. Her mind is in the job market since 'internship'.




