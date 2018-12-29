

shinyServer(function(input, output) {
  
  Text_file <- reactive({
    
    if (is.null(input$file)) {# locate 'file1' from ui.R
      return(NULL) } 
    else{
      Dataset <- readLines(input$file1$datapath)
      
      Dataset  =  str_replace_all(Dataset, "<.*?>", "")
      # get rid of html junk 
      Dataset = Dataset[Dataset!= ""]
      
      str(Dataset)
      
      return(Dataset)
    }
  })
  
  
  
  Udpipe_model = reactive({
    # load english model for annotation from working dir
    Udpipe_model = udpipe_load_model(input$file2$datapath)  # file_model only needed
    return(english_model)
  })
  annotated_object = reactive({
    x <- udpipe_annotate(Udpipe_model(),x = Text_file())
    
    x <- as.data.frame(x)
    
    return(x)
  })
# Calc and render plot    
  output$plot2 = renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      all_nouns = annotated_object() %>% subset(., upos %in% "NOUN") 
      
      top_nouns = txt_freq(all_nouns$lemma)  
      
      wordcloud(top_nouns$key,top_nouns$freq, min.freq = 2,colors = brewer.pal(6, "Dark2") )
    }
  })
  
  
  
  output$plot1 = renderPlot({
    
    if(is.null(input$file)){return(NULL)}
    else{
      cooc <- cooccurrence(   	# try `?cooccurrence` for parm options
        x = subset(annotated_object(), upos %in% input$upos), 
        term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))
      
      wordnetwork <- head(cooc, 35)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
      
      ggraph(wordnetwork, layout = "fr") +  
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "darkgreen") +  
        geom_node_text(aes(label = name), col = "orange", size = 5) +
        
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
        
        labs(title = "Cooccurrences within 3 words distance")
    }
  })
})