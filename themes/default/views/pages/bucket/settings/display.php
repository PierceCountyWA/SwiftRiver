<div id="content" class="settings cf">
	<div class="center">
		<div class="col_12">
			<?php if (isset($errors)): ?>
				<div class="alert-message blue">
				<?php foreach ($errors as $message): ?>
					<p><strong>Uh oh.</strong> <?php echo $message; ?></p>
				<?php endforeach; ?>
				</div>
			<?php endif; ?>
			
			<?php if (isset($messages)): ?>
				<div class="alert-message blue">
				<?php foreach ($messages as $message): ?>
					<p><strong>Success</strong> <?php echo $message; ?></p>
				<?php endforeach; ?>
				</div>
			<?php endif; ?>
			
			<?php echo Form::open(); ?>
			<article class="container base">
				<header class="cf">
					<div class="property-title">
						<h1>Name</h1>
					</div>
				</header>
				<section class="property-parameters">
					<div class="parameter">
						<label for="bucket_name">
							<p class="field">Display name</p>
							<input type="text" value="<?php echo $bucket->bucket_name ?>" name="bucket_name" />
						</label>
					</div>
				</section>
			</article>

			<article class="container base">
				<header class="cf">
					<div class="property-title">
						<h1>Default view</h1>
					</div>
				</header>
				<section class="property-parameters">
					<div class="parameter">
						<select name="default_layout">
							<option value="drops" <?php echo ($bucket->default_layout == "drops") ? 'selected' : ''; ?>>Drops</option>
							<option value="list" <?php echo ($bucket->default_layout == "list") ? 'selected' : ''; ?>>List</option>
							<option value="photos" <?php echo ($bucket->default_layout == "photos") ? 'selected' : ''; ?>>Photos</option>
						</select>
					</div>
				</section>
			</article>
			
			<article class="container base">
				<header class="cf">
					<div class="property-title">
						<h1>Who can view this bucket</h1>
					</div>
				</header>
				<section class="property-parameters">
					<div class="parameter">
						<select name="bucket_publish">
							<option value="1" <?php echo $bucket->bucket_publish ? 'selected' : ''; ?>>Public (Anyone)</option>
							<option value="0" <?php echo $bucket->bucket_publish ? '' : 'selected'; ?>>Private (Collaborators only)</option>
						</select>
					</div>
				</section>
			</article>

			<article class="container base">
				<header class="cf">
					<div class="property-title">
						<h1>Tokens</h1>
					</div>
				</header>
				<section class="property-parameters">
					<div class="parameter">
						<label for="public_token">
							<p class="field">Public Token</p>
							<input type="text" value="<?php echo $bucket->public_token ?>" name="public_token" id="public_token" disabled="disabled" />
							<p class="button-blue button-small generate" style="float: right;">
								<a href="#" title="Generate a new public token. WARNING: The old token will no longer be usable." >Generate</a>
							</p>
						</label>
					</div>
				</section>
			</article>

			<div class="save-toolbar">
				<p class="button-blue"><a href="#" onclick="if ($(this).parents('.save-toolbar').hasClass('visible')) submitForm(this); return false;">Save changes</a></p>
				<p class="button-blank"><a href="#">Cancel</a></p>
			</div>
			<?php echo Form::close(); ?>
		</div>
	</div>
</div>

<script type="text/javascript">
	$(function() {
		$('.generate a').click(function() {
			$.getJSON('<?php echo $bucket->get_base_url(); ?>/settings/display/create_token', function(result) {
				$('#public_token').val(result);
			});
			return false;
		});
	});
</script>
