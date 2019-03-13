# https://github.com/ebu/ai-benchmarking-stt/issues/29
# Schema: 
# [
#  {"text": "hello"},
#  {"text": "world"}
# ]

Feature: Convert reference and hypotheses to native schema
	# Assuming the input has been mormalised before this stage,
	# so here we're just splitting the string on space.
	# Other splitting logic (e.g. hyphens) should be dealt with in the normalisers. 
	

Scenario: Split words at spaces
    Given normalised input
    		"""
    		Mixe'd case-Words   "incl uding"  !rU££1sh?.
    		"""
     When the input is converted to the native scheme
     Then the output is
		    """
		   	[
				{"text":"Mixe'd"},
				{"text":"case-Words"},
				{"text":"\"incl"},
				{"text":"uding\""},
				{"text":"!rU££1sh?."},
			]
			"""