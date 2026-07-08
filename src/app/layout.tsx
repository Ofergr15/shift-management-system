import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Shift Management System',
  description: 'Manage employee shifts and schedules',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className="bg-gray-50 min-h-screen">{children}</body>
    </html>
  )
}
