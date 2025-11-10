import { redirect } from '@sveltejs/kit';

export async function load({ locals }) {
	console.log('=== DASHBOARD LOAD START ===');
	
	const { session, user } = await locals.safeGetSession();
	
	console.log('Session:', session ? 'EXISTS' : 'NULL');
	console.log('User:', user ? {
		id: user.id,
		email: user.email,
		role: user.role
	} : 'NULL');

	if (!session) {
		console.log('No session - returning empty data');
		return {
			session: null,
			user: null,
			pointsAwarded: [],
			pointsGranted: []
		};
	}

	console.log('Fetching points awarded for user_id:', user.id);
	
	// First, let's check if there are ANY messages with points
	const { data: allMessages, error: allError } = await locals.supabase
		.from('messages')
		.select('id, user_id, from_id, points, message_text')
		.not('points', 'is', null);
	
	console.log('ALL messages with points in database:', {
		count: allMessages?.length || 0,
		messages: allMessages,
		error: allError
	});
	
	// Fetch points awarded to the user (messages where user_id matches and points exist)
	// Exclude messages where the user sent points to themselves (from_id = user_id)
	const { data: pointsAwarded, error: awardedError } = await locals.supabase
		.from('messages')
		.select('*')
		.eq('user_id', user.id)
		.neq('from_id', user.id)  // Exclude self-grants
		.not('points', 'is', null)
		.order('sent_at', { ascending: false });

	console.log('Points awarded query result:', {
		count: pointsAwarded?.length || 0,
		error: awardedError
	});

	// Enrich with sender email using RPC function
	if (pointsAwarded && pointsAwarded.length > 0) {
		const senderIds = [...new Set(pointsAwarded.map(m => m.from_id))];
		const senderEmails = {};
		
		for (const senderId of senderIds) {
			const { data } = await locals.supabase.rpc('get_user_email', { user_uuid: senderId });
			senderEmails[senderId] = data || senderId;
		}
		
		pointsAwarded.forEach(message => {
			message.sender_email = senderEmails[message.from_id];
		});
		
		console.log('Enriched points awarded with', Object.keys(senderEmails).length, 'sender emails');
	}

	// Fetch points granted by the user (messages where from_id matches and points exist)
	// Exclude messages where the user received points from themselves (user_id = from_id)
	const { data: pointsGranted, error: grantedError } = await locals.supabase
		.from('messages')
		.select('*')
		.eq('from_id', user.id)
		.neq('user_id', user.id)  // Exclude self-grants
		.not('points', 'is', null)
		.order('sent_at', { ascending: false });

	console.log('Points granted query result:', {
		count: pointsGranted?.length || 0,
		error: grantedError
	});

	// Enrich with recipient email using RPC function
	if (pointsGranted && pointsGranted.length > 0) {
		const recipientIds = [...new Set(pointsGranted.map(m => m.user_id))];
		const recipientEmails = {};
		
		for (const recipientId of recipientIds) {
			const { data } = await locals.supabase.rpc('get_user_email', { user_uuid: recipientId });
			recipientEmails[recipientId] = data || recipientId;
		}
		
		pointsGranted.forEach(message => {
			message.recipient_email = recipientEmails[message.user_id];
		});
		
		console.log('Enriched points granted with', Object.keys(recipientEmails).length, 'recipient emails');
	}

	if (awardedError) {
		console.error('❌ Points awarded error:', awardedError);
		console.error('Error details:', {
			message: awardedError.message,
			code: awardedError.code,
			details: awardedError.details,
			hint: awardedError.hint
		});
	}
	if (grantedError) {
		console.error('❌ Points granted error:', grantedError);
		console.error('Error details:', {
			message: grantedError.message,
			code: grantedError.code,
			details: grantedError.details,
			hint: grantedError.hint
		});
	}

	const result = {
		session,
		user,
		pointsAwarded: pointsAwarded || [],
		pointsGranted: pointsGranted || []
	};
	
	console.log('=== DASHBOARD LOAD END ===');
	console.log('Returning:', {
		hasSession: !!result.session,
		hasUser: !!result.user,
		awardedCount: result.pointsAwarded.length,
		grantedCount: result.pointsGranted.length
	});

	return result;
}

export const actions = {
	login: async ({ request, locals }) => {
		const formData = await request.formData();
		const email = formData.get('email');
		const password = formData.get('password');

		const { error } = await locals.supabase.auth.signInWithPassword({
			email,
			password
		});

		if (error) {
			return { success: false, error: error.message };
		}

		throw redirect(303, '/');
	},

	logout: async ({ locals }) => {
		await locals.supabase.auth.signOut();
		throw redirect(303, '/');
	}
};
