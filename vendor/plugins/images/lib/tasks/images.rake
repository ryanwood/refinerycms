namespace :images do

  desc "Regenerate all thumbnails. Useful for when you've changed size or cropping on the images after images have been uploaded."
  task :regenerate => :environment do
    thumbnails_size = Image.count(:conditions => "parent_id IS NOT NULL")
    puts "Preparing to delete #{thumbnails_size} generated thumbnails"
        
    if Image.destroy_all("parent_id IS NOT null")
      puts "--> #{thumbnails_size} thumbnails deleted"
    else
      puts "There may have been a problem deleting the thumbnails."
    end
    
    originals = Image.originals
    puts "Preparing to regenerate thumbnails for #{originals.size} images"
    
    originals.each do |image|
      begin
        image.save
      rescue Exception => e  
        puts "--> ERROR image #{image.id} could not be saved because #{e.message}"
      end
    end
    
    puts "Image regeneration complete."
  end
  
end