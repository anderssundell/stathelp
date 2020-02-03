library(shiny)
library(tidyverse)
require(gridExtra)

# GLOBAL VARIABLES

func.dicegood <- function(){
  dicepair_1 <- sample(1:6, 2, replace=TRUE)
  return(dicepair_1)
}

func.dicebad <- function(){
  dicepair_2 <- sample(1:12, 2, replace=TRUE)
  
  if (dicepair_2[1] <= 4) {
    dicebad.1 <- dicepair_2[1]
  } else if (dicepair_2[1] == 4 | dicepair_2[1]==5 | dicepair_2[1]==6) {
    dicebad.1 <- 4
  } else if (dicepair_2[1] == 7 | dicepair_2[1]==8 | dicepair_2[1]==9) {
    dicebad.1 <- 5
  } else if (dicepair_2[1] == 10 | dicepair_2[1]==11 | dicepair_2[1]==12) {
    dicebad.1 <- 6
  }
  
  if (dicepair_2[2] <= 4) {
    dicebad.2 <- dicepair_2[2]
  } else if (dicepair_2[2] == 4 | dicepair_2[2]==5 | dicepair_2[2]==6) {
    dicebad.2 <- 4
  } else if (dicepair_2[2] == 7 | dicepair_2[2]==8 | dicepair_2[2]==9) {
    dicebad.2 <- 5
  } else if (dicepair_2[2] == 10 | dicepair_2[2]==11 | dicepair_2[2]==12) {
    dicebad.2 <- 6
  }
  
  dicepair_2 <- c(dicebad.1, dicebad.2)
  return(dicepair_2)
}

# DICE FIGURES DATASETS
# 9 Observations that are either on or off
# One
xvec <- c(1, 1, 1, 2, 2, 2, 3, 3, 3)
yvec <- c(1, 2, 3, 1, 2, 3, 1, 2, 3)
diceset.1 <- data.frame(x = xvec, y = yvec)
diceset.1$value <- as.factor(c(0, 0, 0, 0, 1, 0, 0, 0, 0))

diceset.2 <- data.frame(x = xvec, y = yvec)
diceset.2$value <- as.factor(c(1, 0, 0, 0, 0, 0, 0, 0, 1))

diceset.3 <- data.frame(x = xvec, y = yvec)
diceset.3$value <- as.factor(c(1, 0, 0, 0, 1, 0, 0, 0, 1))

diceset.4 <- data.frame(x = xvec, y = yvec)
diceset.4$value <- as.factor(c(1, 0, 1, 0, 0, 0, 1, 0, 1))

diceset.5 <- data.frame(x = xvec, y = yvec)
diceset.5$value <- as.factor(c(1, 0, 1, 0, 1, 0, 1, 0, 1))

diceset.6 <- data.frame(x = xvec, y = yvec)
diceset.6$value <- as.factor(c(1, 1, 1, 0, 0, 0, 1, 1, 1))

psize <- 6
diceheight <- "75px"

dp1 <- ggplot(diceset.1, aes(x = x, y = y)) +
  geom_point(aes(col = value), size=psize) +
  theme_void() +
  scale_color_manual(values=c("#FFFFFF", "#000000")) +
  theme(legend.position = "none", panel.border = element_rect(fill = NA), aspect.ratio = 1) +
  expand_limits(x = c(0.5, 3.5), y = c(0.5, 3.5))

dp2 <- ggplot(diceset.2, aes(x = x, y = y)) +
  geom_point(aes(col = value), size=psize) +
  theme_void() +
  scale_color_manual(values=c("#FFFFFF", "#000000")) +
  theme(legend.position = "none", panel.border = element_rect(fill = NA), aspect.ratio = 1) +
  expand_limits(x = c(0.5, 3.5), y = c(0.5, 3.5))

dp3 <- ggplot(diceset.3, aes(x = x, y = y)) +
  geom_point(aes(col = value), size=psize) +
  theme_void() +
  scale_color_manual(values=c("#FFFFFF", "#000000")) +
  theme(legend.position = "none", panel.border = element_rect(fill = NA), aspect.ratio = 1) +
  expand_limits(x = c(0.5, 3.5), y = c(0.5, 3.5))

dp4 <- ggplot(diceset.4, aes(x = x, y = y)) +
  geom_point(aes(col = value), size=psize) +
  theme_void() +
  scale_color_manual(values=c("#FFFFFF", "#000000")) +
  theme(legend.position = "none", panel.border = element_rect(fill = NA), aspect.ratio = 1) +
  expand_limits(x = c(0.5, 3.5), y = c(0.5, 3.5))

dp5 <- ggplot(diceset.5, aes(x = x, y = y)) +
  geom_point(aes(col = value), size=psize) +
  theme_void() +
  scale_color_manual(values=c("#FFFFFF", "#000000")) +
  theme(legend.position = "none", panel.border = element_rect(fill = NA), aspect.ratio = 1) +
  expand_limits(x = c(0.5, 3.5), y = c(0.5, 3.5))

dp6 <- ggplot(diceset.6, aes(x = x, y = y)) +
  geom_point(aes(col = value), size=psize) +
  theme_void() +
  scale_color_manual(values=c("#FFFFFF", "#000000")) +
  theme(legend.position = "none", panel.border = element_rect(fill = NA), aspect.ratio = 1) +
  expand_limits(x = c(0.5, 3.5), y = c(0.5, 3.5))


# EMPTY DATASET
dicedata <- data.frame(nr=as.integer(), good=as.integer(), bad=as.integer())
nr_rolls <- 0

pvaldata <- data.frame(nr=as.integer(), meandiff=as.double(), pval=as.double(), m_good=as.double(), m_bad=as.double())

### END GLOBAL STUFF



###################### UI 
# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "shinystyle.css")
  ),
  
  # App title ----
  h2("Vad är signifikans?"),
  h3("Det kortare svaret"),
  p("Det korta svaret är att signifikans är ett mått på hur osannolikt det är att vi ska se en skillnad
    mellan två saker, om det inte finns någon skillnad i verkligheten, bara på grund av slump.
    Till exempel kan det handla om skillnader i attityder mellan unga och gamla i en urvalsundersökning, eller skillnaden mellan
    experiment- och kontrollgrupp i ett experiment."),

  p("Om vi får ett resultat som till exempel visar att äldre är mer politiskt intresserade än
    de unga i en enkätundersökning så är nästa fråga om denna skillnad också återfinns i populationen,
    alltså den större grupp ur vilket vi gjort vårt urval av enkätdeltagare. Till exempel svenska
    folket."),
  
  p("Om signifikansvärdet är 0.723 betyder det att slumpen 723 gånger av 1000 kommer orsaka en så stor
    skillnad som vi uppmätt. Det råkar ibland bli lite för många äldre som är politiskt intresserade.
    Om så är fallet bör vi inte tillmäta skillnaden mellan unga och äldre någon stor vikt - den
    beror ju ändå bara på slumpen."),

  p("Men om signifikansvärdet är lågt, till exempel 0.002, betyder det att slumpen bara orsakar en
    så stor skillnad som vi sett i vårt urval 2 gånger av 1000. Då är det nog mer sannolikt att det
    faktiskt finns en skillnad mellan unga och gamla där ute, i verkligheten."),

  p("När är vi tillräckligt säkra på att det inte är slumpen? Det finns ingen magisk gräns.
    Men konventionen är att man utgår från ett signifikansvärde på 0.050, alltså 50 fall av 1000,
    eller 5%. Om signifikansvärdet är under 0.050 brukar vi alltså säga att skillnaden är
    statistiskt signifikant."),
  
    h3("Det längre svaret"),
  p("Vi ska här gå igenom ett exempel
    som handlar om att undersöka om ett par tärningar är viktade.
    
    För att undersöka detta har vi ett par tärningar som vi är säkra på är okej. Vi kommer
    kasta dem, och kasta det osäkra paret samtidifgt, och se vad summan blir i respektive par.
    Om vi gör det tillräckligt många gånger kommer vi se om medelvärdet blir detsamma (ca 7)
    för båda paren, eller om det blir något annat med de okända tärningarna. Tryck på knappen
    för att kasta tärningarna!"),
  
  # Input: Dice roll button
      actionButton("roll", "Kasta tärningarna"),
  splitLayout(cellWidths = c("14%", "20%", "6%", "5%", "14%", "20%", "6%"), p(), p("Säkra tärningar"), p(), p(), p(), p("Osäkra tärningar"), p()),
  splitLayout(cellWidths = c("10%", "10%", "10%", "10%", "5%", "10%", "10%", "10%", "10%"), p(), plotOutput("dice1", height=diceheight), plotOutput("dice2", height=diceheight), p(), p(), p(), plotOutput("dice3", height=diceheight), plotOutput("dice4", height=diceheight), p()),
  
  p("Vad blev resultatet? Var summan högre i något av paren? Även om det blev så kan vi inte från
    ett enskilt kast avgöra om det var slumpen eller någon systematik som orsakade resultatet.
    Slumpen spelar för stor roll. Vi måste göra det många gånger. Diagrammen nedan visar fördelningen
    av resultaten från tärningskasten från de båda tärningsparen. Ju högre staplar på ett tal,
    desto fler kast som fått det resultatet."),
  
      # Output: Histogram ----
  
#  fluidRow(
#    column(5, plotOutput("dice1"), plotOutput("dice2"), plotOutput("blank"), plotOutput("dice3"), plotOutput("dice4"))
#    ),
#    fluidRow(
#      column(3, plotOutput("histgood"), plotOutput("blank2"), plotOutput("histbad"))


splitLayout(cellWidths = c("40%", "5%", "40%"), plotOutput("histgood", height="200px"), p(), plotOutput("histbad", height="200px")),

p("Antal kast:", textOutput("rolls", inline= TRUE)),
p("Medelvärdesskillnad:", textOutput("meandiff", inline= TRUE)),
p("Signifikansvärde:", textOutput("pval", inline= TRUE)),
p("Och här ser vi en intressant graf som visar medelvärdesskillnaden:"),
plotOutput("meandiffplot", height="200px", width="600px"),

p("Och här ser vi en intressant graf som visar p-värdet:"),
plotOutput("pvalplot", height="200px", width="600px")
)




# Define server logic required to draw a histogram ----
server <- function(input, output, session) {
  
  observeEvent(input$roll, {

    dicegood <- func.dicegood()
    dicebad <- func.dicebad()
    
    good.1 <- dicegood[1]
    good.2 <- dicegood[2]
    bad.1 <- dicebad[1]
    bad.2 <- dicebad[2]
    
    if (good.1 == 1) {
      p1 <- dp1
    } else if (good.1 == 2) {
      p1 <- dp2
    } else if (good.1 == 3) {
      p1 <- dp3
    } else if (good.1 == 4) {
      p1 <- dp4
    } else if (good.1 == 5) {
      p1 <- dp5
    } else if (good.1 == 6) {
      p1 <- dp6
    }
    
    if (good.2 == 1) {
      p2 <- dp1
    } else if (good.2 == 2) {
      p2 <- dp2
    } else if (good.2 == 3) {
      p2 <- dp3
    } else if (good.2 == 4) {
      p2 <- dp4
    } else if (good.2 == 5) {
      p2 <- dp5
    } else if (good.2 == 6) {
      p2 <- dp6
    }    
    
    if (bad.1 == 1) {
      p3 <- dp1
    } else if (bad.1 == 2) {
      p3 <- dp2
    } else if (bad.1 == 3) {
      p3 <- dp3
    } else if (bad.1 == 4) {
      p3 <- dp4
    } else if (bad.1 == 5) {
      p3 <- dp5
    } else if (bad.1 == 6) {
      p3 <- dp6
    }
    
    if (bad.2 == 1) {
      p4 <- dp1
    } else if (bad.2 == 2) {
      p4 <- dp2
    } else if (bad.2 == 3) {
      p4 <- dp3
    } else if (bad.2 == 4) {
      p4 <- dp4
    } else if (bad.2 == 5) {
      p4 <- dp5
    } else if (bad.2 == 6) {
      p4 <- dp6
    }
    
    nr_rolls <<- nr_rolls+1
    dicerolls <- c(nr_rolls, sum(dicegood), sum(dicebad))
    dicedata[nrow(dicedata)+1,] <<- dicerolls
    
    mean_good <- dicedata %>%
      summarize(mean(good)) %>%
      as.double()
    
    mean_bad <- dicedata %>%
      summarize(mean(bad)) %>%
      as.double()
  
    result_pval <- 1
    if(nr_rolls>1){
    result_pval <- t.test(dicedata$good, dicedata$bad)$p.value
    }
    
    pvalsum <- c(nr_rolls, mean_bad - mean_good, result_pval, mean_good, mean_bad)
    pvaldata[nrow(pvaldata)+1,] <<- pvalsum
    
    
    plotgood <- ggplot(dicedata) +
      geom_bar(aes(x=good), col="black", fill="green", width=0.9) +
      theme_minimal() +
      scale_x_continuous(limits=c(1.5, 12.5), breaks=c(0.5, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)) +
      scale_y_continuous(breaks=c(0, 2, 4, 6, 8, 10)) +
      ggtitle(paste("Mean value:", format(round(mean_good, 1), nsmall=1))) +
      expand_limits(y = c(0, 10))
    
    plotbad <- ggplot(dicedata) +
      geom_bar(aes(x=bad), col="black", fill="red", width=0.9) +
      theme_minimal() +
      scale_x_continuous(limits=c(1.5, 12.5), breaks=c(0.5, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)) +
      scale_y_continuous(breaks=c(0, 2, 4, 6, 8, 10)) +
      ggtitle(paste("Mean value:", format(round(mean_bad, 1), nsmall=1))) +
      expand_limits(y = c(0, 10))
  
    plotmeandiff <- ggplot(pvaldata) +
      geom_point(aes(x=nr, y = m_good), col = "green") +
      geom_point(aes(x=nr, y = m_bad), col = "red") +
      geom_line(aes(x=nr, y = m_good), col = "green") +
      geom_line(aes(x=nr, y = m_bad), col = "red") +
      theme_minimal() +
      expand_limits(x = c(1, 50), y = c(2, 12)) +
      scale_y_continuous(breaks=c(2, 4, 6, 8, 10, 12))
    
    plotpval <- ggplot(pvaldata) +
      geom_point(aes(x=nr, y = pval)) +
      geom_line(aes(x=nr, y = pval)) +
      theme_minimal() +
      expand_limits(x = c(1, 50), y = c(0, 1)) +
      scale_y_continuous(breaks=c(0, 0.05, 0.2, 0.4, 0.6, 0.8, 1)) +
      geom_hline(yintercept = 0.05, linetype = "dashed", color = "red")
    
    output$dice1 <- renderPlot({
      p1
    })
    output$dice2 <- renderPlot({
      p2
    })
    output$dice3 <- renderPlot({
      p3
    })
    output$dice4 <- renderPlot({
      p4
    })
    
    output$histgood <- renderPlot({
      plotgood
    })
    
    output$histbad <- renderPlot({
      plotbad
    })
   
    output$meandiffplot <- renderPlot({
      plotmeandiff
    })
     
    output$pvalplot <- renderPlot({
      plotpval
    })

    output$rolls <- renderText(nr_rolls)
    output$meandiff <- renderText(format(round(mean_bad - mean_good, 1), nsmall=1))
    output$pval <- renderText(format(round(result_pval, 2), nsmall=2))
    
  })    
}

shinyApp(ui = ui, server = server)