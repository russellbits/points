<script>
	let { form } = $props();
</script>

<div class="login-container">
	<h2>Login to Points Exchange</h2>
	
	{#if form?.error}
		<div class="error-message">
			{form.error}
		</div>
	{/if}
	
	<form method="POST" action="?/login">
		<div class="form-group">
			<label for="email">Email</label>
			<input 
				type="email" 
				id="email" 
				name="email" 
				required 
				placeholder="your@email.com"
			/>
		</div>
		
		<div class="form-group">
			<label for="password">Password</label>
			<input 
				type="password" 
				id="password" 
				name="password" 
				required 
				placeholder="••••••••"
			/>
		</div>
		
		<button type="submit" class="login-button">Login</button>
	</form>
</div>

<style>
	.login-container {
		max-width: 400px;
		margin: 2rem auto;
		padding: 2rem;
		border: 1px solid #e0e0e0;
		border-radius: 8px;
		background: white;
		box-shadow: 0 2px 8px rgba(0,0,0,0.1);
	}
	
	h2 {
		margin-top: 0;
		margin-bottom: 1.5rem;
		text-align: center;
		color: #333;
	}
	
	.error-message {
		background: #fee;
		color: #c33;
		padding: 0.75rem;
		border-radius: 4px;
		margin-bottom: 1rem;
		font-size: 0.9rem;
	}
	
	.form-group {
		margin-bottom: 1.25rem;
	}
	
	label {
		display: block;
		margin-bottom: 0.5rem;
		font-weight: 500;
		color: #555;
	}
	
	input {
		width: 100%;
		padding: 0.75rem;
		border: 1px solid #ddd;
		border-radius: 4px;
		font-size: 1rem;
		box-sizing: border-box;
	}
	
	input:focus {
		outline: none;
		border-color: #4a90e2;
		box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
	}
	
	.login-button {
		width: 100%;
		padding: 0.875rem;
		background: #4a90e2;
		color: white;
		border: none;
		border-radius: 4px;
		font-size: 1rem;
		font-weight: 600;
		cursor: pointer;
		transition: background 0.2s;
	}
	
	.login-button:hover {
		background: #357abd;
	}
	
	.login-button:active {
		transform: translateY(1px);
	}
</style>
