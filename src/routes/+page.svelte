<script>
	import LoginForm from '$lib/components/LoginForm.svelte';
	
	let { data, form } = $props();
	
	// Log data on mount and when it changes
	$effect(() => {
		console.log('=== CLIENT-SIDE DATA ===');
		console.log('Session exists:', !!data.session);
		console.log('User:', data.user?.email || 'Not logged in');
		console.log('Points Awarded:', data.pointsAwarded);
		console.log('Points Granted:', data.pointsGranted);
		console.log('Form errors:', form);
	});
</script>

{#if !data.session}
	<LoginForm {form} />
{:else}
	<div class="dashboard">
		<header class="dashboard-header">
			<h1>Points Exchange Dashboard</h1>
			<div class="user-info">
				<span>Welcome, {data.user.email}</span>
				<form method="POST" action="?/logout">
					<button type="submit" class="logout-button">Logout</button>
				</form>
			</div>
		</header>

		<div class="dashboard-content">
			<section class="points-section">
				<h2>Points Awarded</h2>
				{#if data.pointsAwarded.length === 0}
					<p class="empty-state">No points awarded yet.</p>
				{:else}
					<table class="points-table">
						<thead>
							<tr>
								<th>From</th>
								<th>When</th>
								<th>Points</th>
								<th>Message</th>
							</tr>
						</thead>
						<tbody>
							{#each data.pointsAwarded as message}
								<tr>
									<td>{message.sender_email || message.from_id}</td>
									<td>{new Date(message.sent_at).toLocaleDateString()}</td>
									<td class="points-cell awarded">+{message.points}</td>
									<td class="message-cell">{message.message_text || 'No message'}</td>
								</tr>
							{/each}
						</tbody>
					</table>
				{/if}
			</section>

			<section class="points-section">
				<h2>Points Granted</h2>
				{#if data.pointsGranted.length === 0}
					<p class="empty-state">No points granted yet.</p>
				{:else}
					<table class="points-table">
						<thead>
							<tr>
								<th>To</th>
								<th>When</th>
								<th>Points</th>
								<th>Message</th>
							</tr>
						</thead>
						<tbody>
							{#each data.pointsGranted as message}
								<tr>
									<td>{message.recipient_email || message.user_id}</td>
									<td>{new Date(message.sent_at).toLocaleDateString()}</td>
									<td class="points-cell granted">-{message.points}</td>
									<td class="message-cell">{message.message_text || 'No message'}</td>
								</tr>
							{/each}
						</tbody>
					</table>
				{/if}
			</section>
		</div>
	</div>
{/if}

<style>
	:global(body) {
		margin: 0;
		padding: 0;
		font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
		background: #f5f5f5;
	}

	.dashboard {
		max-width: 1200px;
		margin: 0 auto;
		padding: 2rem;
	}

	.dashboard-header {
		background: white;
		padding: 1.5rem 2rem;
		border-radius: 8px;
		margin-bottom: 2rem;
		box-shadow: 0 2px 4px rgba(0,0,0,0.1);
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.dashboard-header h1 {
		margin: 0;
		color: #333;
		font-size: 1.75rem;
	}

	.user-info {
		display: flex;
		align-items: center;
		gap: 1rem;
	}

	.user-info span {
		color: #666;
	}

	.logout-button {
		padding: 0.5rem 1rem;
		background: #e74c3c;
		color: white;
		border: none;
		border-radius: 4px;
		cursor: pointer;
		font-size: 0.9rem;
		font-weight: 500;
		transition: background 0.2s;
	}

	.logout-button:hover {
		background: #c0392b;
	}

	.dashboard-content {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 2rem;
	}

	@media (max-width: 768px) {
		.dashboard-content {
			grid-template-columns: 1fr;
		}
	}

	.points-section {
		background: white;
		padding: 1.5rem;
		border-radius: 8px;
		box-shadow: 0 2px 4px rgba(0,0,0,0.1);
	}

	.points-section h2 {
		margin-top: 0;
		margin-bottom: 1.25rem;
		color: #333;
		font-size: 1.25rem;
		border-bottom: 2px solid #4a90e2;
		padding-bottom: 0.5rem;
	}

	.empty-state {
		color: #999;
		text-align: center;
		padding: 2rem;
		font-style: italic;
	}

	.points-table {
		width: 100%;
		border-collapse: collapse;
		font-size: 0.95rem;
	}

	.points-table thead {
		background: #f8f9fa;
		border-bottom: 2px solid #dee2e6;
	}

	.points-table th {
		padding: 0.75rem;
		text-align: left;
		font-weight: 600;
		color: #495057;
		font-size: 0.875rem;
		text-transform: uppercase;
		letter-spacing: 0.5px;
	}

	.points-table tbody tr {
		border-bottom: 1px solid #e9ecef;
		transition: background-color 0.2s;
	}

	.points-table tbody tr:hover {
		background-color: #f8f9fa;
	}

	.points-table tbody tr:last-child {
		border-bottom: none;
	}

	.points-table td {
		padding: 0.875rem 0.75rem;
		color: #333;
	}

	.points-cell {
		font-weight: 700;
		font-size: 1.1rem;
		white-space: nowrap;
	}

	.points-cell.awarded {
		color: #27ae60;
	}

	.points-cell.granted {
		color: #e74c3c;
	}

	.message-cell {
		max-width: 300px;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
		color: #666;
	}

	@media (max-width: 768px) {
		.points-table {
			font-size: 0.85rem;
		}

		.points-table th,
		.points-table td {
			padding: 0.5rem 0.375rem;
		}

		.message-cell {
			max-width: 150px;
		}
	}
</style>
