# Kindle2Folder.rb Script
# This example script uses the kindle-highlights code to create a seperate .txt file for each book in your collection in the 
# Amazon Kindle Notebook.  Each file contains the name of the book and author, and then adds each highlight below it with the 
# page number/location and any associated notes.  Finally it adds a link to the highlight in the desktop version of the kindle 
# app using the "kindle://" url scheme.

require 'kindle_highlights'

def sanitize_filename(filename) #Function to remove invalid symbols from filenames
  fn = filename.split /(?<=.)\.(?=[^.])(?!.*\
  fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }
  return fn.join '.'
end

kindle = KindleHighlights::Client.new(  #Add amazon login details below
  email_address: "aaa@aaa.com",
  password: "password"
  )

folder = File.expand_path('~/Kindle') #Folder you want to store the txt files (in markdown format) in...

kindle.books.each do |book|
  fname = folder+"/"+sanitize_filename(book.title)+".txt"
  print book.title+"\r\n" #Print name of Book to console so you can track progress
  bookfile = File.open(fname, "w")
	bookfile.puts "# #{book.title} by #{book.author} \r\n" #Header of the Book Title and Author
	book.highlights_from_amazon.each do |highlight|
		bookfile.puts "#{highlight.text} _#{highlight.page}_ \r\n" #Insert Highlighted Text and the Page Number
		if highlight.note.present?
	  		bookfile.puts "**Note:**  #{highlight.note} \r\n" #If there's a Note attached to the highlight add this below the highlighted text
		end
	bookfile.puts "\r\n [Open in Kindle App](kindle://book?action=open&asin=#{book.asin}&location=#{highlight.location})\r\n\r\n" #Add a link to the highlight in the Kindle App
	end
bookfile.close
end
