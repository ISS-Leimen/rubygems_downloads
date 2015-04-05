require 'gems'

=begin
usage:
first create a ~/.gem/credentials as below
---
:rubygems_api_key: XXXXXXX
=end

# get { gem_name:=> { version:=> { date:=>download_times } } }
class GemMiner

	# initialize the class with the gem_name, input and output formulation
	def initialize(gem_name)
		@gem_name = gem_name
		@hash=Hash.new{|h,k| h[k] = Hash.new(&h.default_proc)}
	end

	# scan all the versions of a gem
	def get_vers_list
		vers = Gems.versions @gem_name
		vers_list=[]
		vers.each do |ver|
			vers_list << ver["number"]
		end
		vers_list
	end

	# check the downloads of a version series
	def get_ver_downloads(ver)
		Gems.downloads @gem_name, ver
	end

	# get yesterday downloads of a specific version
	def get_ver_yesterday_downloads (ver)
		downloads = Gems.downloads @gem_name, ver, Date.today-1, Date.today-1		
	end

	# save the downloads data to a structured hash_table
	def save_to_hash(downloads,ver)
		downloads.each do |k,v|
			@hash[@gem_name][ver][k] = v
		end
	end

	# call the method to get what needed in a hash format
	def get_versions_downloads_list
		vers_list = get_vers_list
		vers_list.each do |ver|
			downloads = get_ver_downloads(ver)
			save_to_hash(downloads,ver)
		end
		@hash
	end

	# call the method to get the updating downloads time ( yesterday )
	def get_yesterday_downloads
		vers_list = get_vers_list
		vers_list.each do |ver|
			downloads = get_ver_yesterday_downloads(ver)
			save_to_hash(downloads,ver)
		end
		@hash
	end
end


