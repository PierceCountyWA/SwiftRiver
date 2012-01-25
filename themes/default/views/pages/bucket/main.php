<article>
	<div class="cf center page-title">
		<hgroup class="edit">
			<h1><span class="edit_trigger" title="bucket" id="edit_<?php echo $bucket->id; ?>" onclick=""><?php echo $bucket->bucket_name; ?></span></h1>
		</hgroup>
	</div>
	
	<div class="center canvas">
		<section class="panel">		
			<nav class="cf">
				<ul class="views">
					<li class="droplets active"><a href="#"><?php echo __('Droplets');?></a></li>
					<?php
					// SwiftRiver Plugin Hook -- Add Bucket Nav Item
					Swiftriver_Event::run('swiftriver.bucket.nav', $bucket);
					?>
					<li class="view_panel"><a href="<?php echo $more; ?>"><span class="arrow"></span>More</a></li>
				</ul>
				<ul class="actions">
					<li class="view_panel"><a href="<?php echo $settings; ?>" class="filter"><span class="icon"></span><?php echo __('Bucket Settings'); ?></a></li>
				</ul>
			</nav>
			<div class="panel_body"></div>
		</section>

		<div class="trend_container cf">
			<?php echo $droplets_list; ?>
		</div>

	</div>
</article>	