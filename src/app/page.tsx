'use client'

import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'

export default function Home() {
  const [connected, setConnected] = useState<boolean | null>(null)

  useEffect(() => {
    async function checkConnection() {
      const { error } = await supabase.from('shifts').select('count', { count: 'exact', head: true })
      setConnected(!error || error.code === '42P01') // table might not exist yet
    }
    checkConnection()
  }, [])

  return (
    <main className="max-w-4xl mx-auto p-8">
      <h1 className="text-3xl font-bold text-gray-900 mb-4">
        Shift Management System
      </h1>
      <div className="bg-white rounded-lg shadow p-6">
        <p className="text-gray-600 mb-4">
          Welcome to the Shift Management System.
        </p>
        <div className="flex items-center gap-2">
          <div className={`w-3 h-3 rounded-full ${
            connected === null ? 'bg-yellow-400' : connected ? 'bg-green-400' : 'bg-red-400'
          }`} />
          <span className="text-sm text-gray-500">
            {connected === null ? 'Checking Supabase connection...' : connected ? 'Connected to Supabase' : 'Not connected - check env variables'}
          </span>
        </div>
      </div>
    </main>
  )
}
