<?php

namespace App\Http\Controllers;

use App\Models\Email;
use Illuminate\Http\Request;

class EmailController extends Controller
{
    public function index()
    {
        $emails = Email::all();
        return response()->json($emails);
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required',
            'appointee' => 'required',
            'status' => 'required',
            'last_email' => 'required|date',
        ]);

        $email = Email::create([
            'title' => $request->title,
            'appointee' => $request->appointee,
            'status' => $request->status,
            'last_email' => $request->last_email,
        ]);

        return response()->json($email, 201);
    }
}

