
  --[[ ########## List Features ########## ]--

    # Note:       Please add new features to this list!
    #
    # Summary:    List all features for quick reference
    # Returns:    Nothing
    # Parameters: None
    # Author:     Adam Buchweitz
    # ]]

u.featureList = function()
    print("\n\tFeature List:\n"..
    "\n\t+ Global variables for dynamic resolution"..
    "\n\t+ Super simple saving and loading"..
    "\n\t+ Shortened reference points, passible as arguments to all display objects"..
    "\n\t+ Insert multiple objects into a group"..
    "\n\t+ Automatic retina-ready text"..
    "\n\t+ Paragraphs"..
    "\n\t+ Exposed API: timer.cancelAll()"..
    "\n\t+ Safe timer.cancel()"..
    "\n\t+ Crossfade background audio"..
    "\n\t+ Play SFX based on registered true/false variable"..
    "\n\t+ Simulator-friendly webPopups"..
    "\n\t+ Print installed font names with printFonts()"..
    "\n\t+ Initialize and globalize a font with one line"..
    "\n\t+ Execute a function if internet is detected, execute another if not connected"..
    "\n\t+ Global information handling"..
    "\n\t+ Extended print statement")
end
u.listFeatures = u.featureList
