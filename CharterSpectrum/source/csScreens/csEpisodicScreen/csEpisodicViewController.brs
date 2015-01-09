' 
' Author: Satyanand
' Summary of last revision: $Id$
'

'*******EpisodicView Screen*******
function showEpisodesListViewController(episodeList as object) as object

    screenFactoryInstance = screenFactorySharedInstance()
    posterWrapper = screenFactoryInstance.makeWrapper("roPosterScreen")
    
    posterWrapper.Screen.setListStyle("flat-episodic")
    posterWrapper.Screen.SetBreadcrumbText("Show Title", "Episodes")
    
    episodesData = GetEpisodeList(episodeList)

    posterWrapper.Screen.SetContentList(episodesData)
    posterWrapper.Screen.SetFocusedListItem(1)    
    posterWrapper.EpisodesData = episodesData
    posterWrapper.addEventListener("isListItemSelected", Function(wrapper as object,screen as object,msg as object)
            
        row = msg.GetIndex()
        column = msg.GetData()

            'Temperorly point this Later change it
            detailData = createobject("roAssociativeArray")
            detailData = wrapper.EpisodesData[row]
                        
            detailScreen = DetailViewController( detailData,"Show Title",detailData.Title)
            detailScreen.showAndListen()
    End Function)
    
    return posterWrapper

end function

Function GetEpisodeList(serials as object) as object

    episodes = serials.EpisodeDetails
    
    Logger().log(5, "In getRowItems() Given category : ")
    
    episodeList = []
    
    if episodes <> invalid       
      
        for each tempEpisode in episodes
                
                episodeContent = CreateObject("roAssociativeArray")           
                episodeContent.id=   tempEpisode.id
                episodeContent.Title = tempEpisode.title
                episodeContent.Description=   tempEpisode.description
                 
                episodeContent.category = tempEpisode.category
                episodeContent.SDPosterURL = tempEpisode.Image
                episodeContent.HDPosterURL = tempEpisode.Image
                
                'Need to Set These Properly
                episodeContent.ShortDescriptionLine1 = tempEpisode.TitleSeason
                episodeContent.ShortDescriptionLine2 = tempEpisode.TitleSeason
                                
                episodeContent.Stream ={Url:tempEpisode.Url}
                episodeContent.Rating=   tempEpisode.Rating
                episodeContent.StarRating=   tempEpisode.StarRating
                episodeContent.ReleaseDate=   tempEpisode.ReleaseDate
                episodeContent.Length=   tempEpisode.Length
                'episodeContent.StreamFormat= tempEpisode.StreamFormat        
                'episodeContent.Actors=getList(tempEpisode.Actors)
               
                episodeList.push( episodeContent )
           
        end for
    end if 
    
    return episodeList

end Function



