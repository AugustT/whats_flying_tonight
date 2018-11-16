rm(list = ls())

# Compress Richards new images
library(jpeg)
library(imager)

new_images_path <- 'www/images/From Richard Fox Nov18/'

files <- list.files(path = new_images_path, pattern = 'jpg$', full.names = TRUE)

dir.create(path = file.path(new_images_path, 'compressed'))

for(file in files){
  
  print(file)
  img <- readJPEG(source = file)
  writeJPEG(image = img,
            target = file.path(dirname(file),
                               'compressed',
                               basename(file)),
            quality = 0.3)
  
}

# Manually move all files into the correct folders, add the large file for the thumbnail 
# to a folder called thumbnail

# As you go fill in "additional images.csv" You can get some species details from the
# species data file
load('data/UKMoths/speciesData_newNames2017.rdata')
View(dplyr::filter(speciesDataRaw, NAME_ENGLISH == "The Many-lined"))
# View(dplyr::filter(speciesDataRaw, NAME == "Hadena caesia"))
# sometimes the URL needs updating
# speciesDataRaw[speciesDataRaw$NAME_ENGLISH == 'White-mantled Wainscot' &
#                 !is.na(speciesDataRaw$NAME_ENGLISH), 'URL'] <- "https://ukmoths.org.uk/species/archanara-neurica/"
save(speciesDataRaw, file = 'data/UKMoths/speciesData_newNames2017.rdata')


# Find all the thumbnail directories that dont have a thumbnail but do have a big image
dirs <- list.dirs('www/images/species', recursive = TRUE, full.names = TRUE)
tdirs <- dirs[basename(dirs) == 'thumbnail']

tn <- NULL

for (i in tdirs){
  fs <- list.files(i, full.names = TRUE)
  if(length(fs) > 0){
    if(!any(grepl('^thumbnail', basename(fs)))){
      tn <- c(tn, fs)
    }
  }
}

tn
minD <- 150

for(i in tn){
  
  org_path <- i

  if(!file.exists(org_path)) stop('File', i, 'thumbnail does not exist')
  
  # Load the image
  image <- load.image(org_path)
  
  # plot(image)
  ratio <- dim(image)[2] / minD
  
  # resize
  image_resized <- resize(image,
                          size_x = dim(image)[1]/ratio,
                          size_y = dim(image)[2]/ratio)
  
  # plot(image_resized)
  
  save.image(im = image_resized,
             file = file.path(dirname(i), paste0('thumbnail_', basename(i))),
             quality = 1)
  
}
