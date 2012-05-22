context("lua.u", function()
	context("core", function()
		require 'spec.core.comm'
		require 'spec.core.data'
		require 'spec.core.featurelist'
		require 'spec.core.misc'
		require 'spec.core.shorthand'
		require 'spec.core.string'
		require "spec.core.table"
		require "spec.core.tips"
		require "spec.core.welcome"
	end)

	context("display", function()
		require "spec.display.displayobjects"
		require "spec.display.newcircle"
		require "spec.display.newgroup"
		require "spec.display.newimage"
		require "spec.display.newimagerect"
		require "spec.display.newparagraph"
		require "spec.display.newrect"
		require "spec.display.newroundedrect"
		require "spec.display.referencepoints"
		require "spec.display.retinatext"
		require "spec.display.sprite"
	end)

	context("timer", function()
	require "spec.timer.safetimer"
		require "spec.timer.timer"
	end)

	context("util", function()
		require "spec.util.beta"
		require "spec.util.contentscale"
		require "spec.util.crossplatformfilename"
		require "spec.util.fonts"
		require "spec.util.internet"
		require "spec.util.musiccrossfade"
		require "spec.util.print"
		require "spec.util.safewebpopups"
		require "spec.util.sfx"
		require "spec.util.transitions"
	end)
end)