import { NextRequest, NextResponse } from 'next/server';
import Database from 'better-sqlite3';

export async function GET(_request: NextRequest) { // eslint-disable-line @typescript-eslint/no-unused-vars
  try {
    // Connect to the SQLite database
    const db = new Database('/app/data/noxs.db');

    // Enable Write-Ahead Logging (WAL) for better concurrency (optional but recommended)
    db.pragma('journal_mode = WAL');

    // Query the users table
    const users = db.prepare('SELECT * FROM users').all();

    // Close the database connection
    db.close();

    // Return the result as JSON
    return NextResponse.json({ message: 'Database connected successfully', users }, { status: 200 });
  } catch (error: unknown) {
    // Type narrowing to safely access error.message
    const errorMessage = error instanceof Error ? error.message : String(error);
    console.error('Database error:', error);
    return NextResponse.json({ error: 'Failed to connect to the database', details: errorMessage }, { status: 500 });
  }
}