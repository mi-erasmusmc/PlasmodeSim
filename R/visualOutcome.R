#' simulate a new outcome
#'
#' @param data a data set as returned by newOutcomesParameters
#'
#' @return returns a boxplot for the frequencies of the outcome
#' @export
#'
visualOutcome <- function( plpData,
                           noSimulations,
                           noPersons,
                           parameters ){

  newprops<- newPropsParameters(  plpData, parameters, "logistic")
  obsfreq<- c()
  for(i in 1:noSimulations){
    newout <- newOutcomes(noPersons ,newprops$newProps )
    obsfreq<- obsfreq %>%
      append(sum(newout$newOutcomes)/ noPersons)
  }
  obsfreq= data.frame('obsfreq'= obsfreq)


  part <- plpData$outcomes %>%
          filter( outcomeId== 3) %>%
          count() %>%
          as.integer()

  total <- length(plpData$cohorts$targetId)
  plotGreenLine <-  part/total

  redlines<- theoreticalExpectation(plpData, parameters)
  #return(redlines)
  #return(redlines)
  #return(obsfreq)
   ggplot2::ggplot(obsfreq, ggplot2::aes(obsfreq))+
   ggplot2::geom_histogram(binwidth=0.025)+
   ggplot2::geom_vline(xintercept =plotGreenLine, col='green')+
   ggplot2::geom_vline(xintercept =redlines , col='red')+
   ggplot2::coord_cartesian(xlim=c(-0.1,1.1))+
   ggplot2::ggtitle(paste(
    "histogram of the frequency of the outcome for",
    noSimulations,
    "simulations with",
    noPersons,
    "persons."))

  }
